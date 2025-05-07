#!/bin/bash

# Download vegeta load testing tool
curl -LO 'https://github.com/tsenart/vegeta/releases/download/v12.12.0/vegeta_12.12.0_linux_386.tar.gz'

# Extract the tool
tar -xvzf vegeta_12.12.0_linux_386.tar.gz

# Set your Cloud Run URL (replace YOUR_REGION with your actual region)
CLOUD_RUN_URL=$(gcloud run services describe helloworld --region=YOUR_REGION --format='value(status.url)')
echo "Cloud Run URL: $CLOUD_RUN_URL"

# Generate traffic (200 requests per second for 5 minutes)
echo "Starting load test: 200 requests per second for 5 minutes"
echo "GET $CLOUD_RUN_URL" | ./vegeta attack -duration=300s -rate=200 > results.bin

# Display results summary
./vegeta report results.bin
echo "Load test complete!"
