# Detailed Setup Guide

This guide provides more detailed instructions for setting up the Monitoring and Logging for Cloud Run Function project.

## Prerequisites

1. A Google Cloud Platform account
2. The `gcloud` CLI tool installed (or use Cloud Shell)
3. Required APIs enabled:
   - Cloud Run API
   - Cloud Functions API
   - Cloud Monitoring API
   - Cloud Logging API

## Step 1: Enable Required APIs

You can enable the required APIs using the following commands:

```bash
gcloud services enable run.googleapis.com
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable monitoring.googleapis.com
gcloud services enable logging.googleapis.com
```

## Step 2: Deploy the Cloud Run Function

### Option 1: Using the Google Cloud Console

1. Navigate to Cloud Run in the console
2. Click "Write a Function"
3. Configure as follows:
   - Service Name: helloworld
   - Region: Your preferred region
   - Runtime: Node.js 22
   - Authentication: Allow unauthenticated invocations
4. Under "Container(s), Volumes, Networking, Security":
   - Set Execution environment to "second generation"
   - Set Maximum number of instances to 5
5. Click "Create" and then "Save and Redeploy"

### Option 2: Using gcloud CLI

1. Create a directory for your function:
   ```bash
   mkdir helloworld-function
   cd helloworld-function
   ```

2. Create the `index.js` file with the function code from this repository

3. Create the `package.json` file from this repository

4. Deploy the function:
   ```bash
   gcloud functions deploy helloworld \
     --gen2 \
     --runtime=nodejs22 \
     --region=YOUR_REGION \
     --source=. \
     --entry-point=helloWorld \
     --trigger-http \
     --allow-unauthenticated \
     --max-instances=5
   ```

## Step 3: Generate Test Traffic

1. Run the `traffic-generator.sh` script provided in this repository:
   ```bash
   chmod +x traffic-generator.sh
   # Edit the script to update YOUR_REGION
   ./traffic-generator.sh
   ```

2. Alternatively, run the commands manually:
   ```bash
   curl -LO 'https://github.com/tsenart/vegeta/releases/download/v12.12.0/vegeta_12.12.0_linux_386.tar.gz'
   tar -xvzf vegeta_12.12.0_linux_386.tar.gz
   CLOUD_RUN_URL=$(gcloud run services describe helloworld --region=YOUR_REGION --format='value(status.url)')
   echo "GET $CLOUD_RUN_URL" | ./vegeta attack -duration=300s -rate=200 > results.bin
   ```

## Step 4: Create a Logs-Based Metric

1. Navigate to Logging > Logs Explorer in the console
2. Filter logs for your Cloud Run function:
   - Resource: Cloud Run Revision > helloWorld
3. Click "Run query"
4. Click "Actions" > "Create metric"
5. Configure the metric:
   - Metric Type: Distribution
   - Name: CloudRunFunctionLatency-Logs
   - Field name: httpRequest.latency
6. Click "Create metric"

## Step 5: Explore Metrics

1. Navigate to Monitoring > Metrics Explorer
2. Select the metric:
   - Resource: Cloud Run Revision
   - Metric: Logs-based metric > Logging/user/CloudRunFunctionLatency-Logs
3. Change visualization as needed
4. Experiment with different metrics and visualizations

## Step 6: Create a Custom Dashboard

1. Navigate to Monitoring > Dashboards
2. Click "Create Custom Dashboard"
3. Add widgets for:
   - Request Count (stacked bar)
   - Latency Distribution (heatmap)
   - Mean Request Latency (line)
   - CPU Allocation (stacked bar)
4. Name the dashboard "Cloud Run Function Custom Dashboard"

## Troubleshooting

### Metric Not Showing Up

If your log-based metric doesn't appear:
- Uncheck "Active" in the metric selection dropdown
- Wait 5-10 minutes for logs to be processed
- Generate more traffic to ensure sufficient data
- Verify the metric name and field are correct

### Function Deployment Issues

If deployment fails:
- Check that required APIs are enabled
- Verify your permissions in the project
- Check for syntax errors in your function code
- Review Cloud Build logs for detailed error information

### Traffic Generation Issues

If traffic generation isn't working:
- Verify the Cloud Run URL is correct
- Check that the function allows unauthenticated invocations
- Try accessing the URL directly in a browser
- Check firewall rules if using from outside Cloud Shell
