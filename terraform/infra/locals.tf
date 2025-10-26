locals {

    tags = {
        "dev": "development"
    }

    storage_account = {
        dev =  {
            "account_tier": "Standard",
            "account_replication_type": "LRS"
        }
    }
    
    databricks = {
        dev = {
            "sku": "standard"
        }
    }
}