import datetime
import logging
import os
from azure.storage.blob import BlobServiceClient

def storage_writer():
    # Retrieve the connection string and container name from environment variables
    connection_string = os.environ["STORAGE_ACCOUNT_CONNECTION_STRING"]
    container_name = os.environ["STORAGE_CONTAINER_NAME"]

    # Create BlobServiceClient and ContainerClient instances
    blob_service_client = BlobServiceClient.from_connection_string(connection_string)
    container_client = blob_service_client.get_container_client(container_name)
    
    
    # Check if the container already exists
    if not container_client.exists():
        # Create the container if it doesn't exist
        container_client.create_container()
        logging.info(f"Container '{container_name}' created")


    # Generate a unique blob name using the current date and time
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    blob_name = f"data_{timestamp}.txt"

    # Define the data to be written to the blob
    data = "Hello, Azure Storage!"

    # Upload the data to the blob
    blob_client = container_client.get_blob_client(blob_name)
    blob_client.upload_blob(data, overwrite=True)

    logging.info(f"Data written to blob: {blob_name}")
