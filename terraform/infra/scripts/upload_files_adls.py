import sys
import argparse
import logging
from pathlib import Path

from azure.storage.filedatalake import DataLakeServiceClient

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),  
        logging.FileHandler('scripts/logs/upload_files_adls.log')  
    ]
)

def get_service_client(storage_account_name, storage_account_key):
    """
    Create a DataLakeServiceClient instance to interact with Azure Data Lake.

    Args:
        storage_account_name (str): Azure Storage account name.
        storage_account_key (str): Azure Storage account key.

    Returns:
        DataLakeServiceClient: Client for interacting with Azure Data Lake.
    """
    try:
        service_client = DataLakeServiceClient(
            account_url=f"https://{storage_account_name}.dfs.core.windows.net",
            credential=storage_account_key
        )
        return service_client
    
    except Exception as e:
        logging.error(f"Error creating DataLakeServiceClient: {e}", exc_info=True) 
        raise Exception(f"Error creating DataLakeServiceClient: {e}")


def upload_files(file_system_client, local_root_folder_path: Path, extension: str = None):
    """
    Upload files from a local directory to Azure Data Lake.

    Args:
        file_system_client (FileSystemClient): Client used to interact with a specific file system (container) in Azure Data Lake.
        local_root_folder_path (Path): Local directory path to search for files.
        extension (str, optional): File extension filter (e.g., '.json'). If None, upload all files.

    Raises:
        Exception: If any error occurs during the upload process.
    """

    if extension:
        files = list(local_root_folder_path.rglob(f'*{extension}'))
    else:
        files = list(local_root_folder_path.rglob('*'))

    files = [f for f in files if f.is_file()]

    if not files:
        logging.warning(f"No files found in {local_root_folder_path} with extension '{extension or 'any'}'")
        return
    
    try:
        for local_file_path in files:
            logging.info(f"Uploading file: {local_file_path}")
            relative_path = local_file_path.relative_to(local_root_folder_path)
            file_client = file_system_client.get_file_client(relative_path)
            with open(local_file_path, "rb") as file_data:
                file_client.upload_data(file_data, overwrite=True)
    except Exception as e:
        logging.error(f"Error during file upload process: {e}", exc_info=True)
        raise

def main():
    parser = argparse.ArgumentParser(description="Upload files to Azure Data Lake.")
    parser.add_argument('storage_account_name', help="Azure Storage account name.")
    parser.add_argument('storage_account_key', help="Azure Storage account key.")
    parser.add_argument('storage_container_name', help="Azure Storage container (file system) name.")
    parser.add_argument('--local-path', default="../../data", help="Local directory containing files to upload.")
    parser.add_argument('--extension', default=None, help="Filter files by extension (e.g. .json). If not set, upload all files.")
    args = parser.parse_args()

    try:
        service_client = get_service_client(args.storage_account_name, args.storage_account_key)
        file_system_client = service_client.get_file_system_client(file_system=args.storage_container_name)
        local_root_folder_path = Path(args.local_path)

        upload_files(file_system_client, local_root_folder_path)
    except Exception as e:
        logging.error(f"Upload failed : {e}", exc_info=True)
        sys.exit(1)

if __name__ == "__main__":
    main()


