import logging
import argparse
from pathlib import Path
from azure.storage.filedatalake import DataLakeServiceClient

logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),  
        logging.FileHandler('upload_files.log')  
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


def upload_files(file_system_client, local_root_folder_path: Path):
    """
    Upload JSON files from a local directory to Azure Data Lake.

    Args:
        file_system_client (FileSystemClient): Client used to interact with a specific file system (container) in Azure Data Lake.
        local_root_folder_path (Path): Local directory path to search for files.
    """
    try:
        for local_file_path in local_root_folder_path.rglob('*.json'):
            logging.info(f"Uploading file: {local_file_path}")
            
            file_client = file_system_client.get_file_client(local_file_path.relative_to(local_root_folder_path))

            with open(local_file_path, "rb") as file_data:
                file_contents = file_data.read()
                file_client.upload_data(file_contents, overwrite=True) 

    except Exception as e:
        logging.error(f"Error during file upload process: {e}", exc_info=True) 
        raise Exception(f"Error during file upload process: {e}")


def main():
    parser = argparse.ArgumentParser(description="Upload JSON files to Azure Data Lake.")
    parser.add_argument('storage_account_name', help="Azure Storage account name.")
    parser.add_argument('storage_account_key', help="Azure Storage account key.")
    parser.add_argument('storage_container_name', help="Azure Storage container name.")
    args = parser.parse_args()

    service_client = get_service_client(args.storage_account_name, args.storage_account_key)
    file_system_client = service_client.get_file_system_client(file_system=args.storage_container_name)
    local_root_folder_path = Path("../data")

    upload_files(file_system_client, local_root_folder_path)


if __name__ == "__main__":
    main()
