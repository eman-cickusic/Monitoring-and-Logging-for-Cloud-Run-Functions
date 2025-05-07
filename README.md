# Monitoring and Logging for Cloud Run Functions

This repository provides a step-by-step guide on how to set up monitoring and logging for a Cloud Run function on Google Cloud Platform. It includes instructions for creating a simple "Hello World" Cloud Run function, configuring logs-based metrics, using Metrics Explorer to view performance data, and creating custom monitoring dashboards.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Setup](#project-setup)
- [Task 1: Create a Cloud Run Function](#task-1-create-a-cloud-run-function)
- [Task 2: Create a Logs-Based Metric](#task-2-create-a-logs-based-metric)
- [Task 3: Use Metrics Explorer](#task-3-use-metrics-explorer)
- [Task 4: Create Custom Dashboard](#task-4-create-custom-dashboard)
- [Repository Contents](#repository-contents)
- [References](#references)

## Overview

This project demonstrates how to:
- Deploy a simple Cloud Run function
- Generate traffic to the function for testing
- Create logs-based metrics to monitor function performance
- Visualize metrics in the Google Cloud Console
- Create custom dashboards for ongoing monitoring

## Video

https://youtu.be/EazaGxFQ0tw


## Prerequisites

- Google Cloud Platform account
- Basic knowledge of JavaScript/Node.js
- Understanding of cloud monitoring concepts

## Project Setup

1. Access the Google Cloud Console
2. Ensure you have the necessary permissions to create resources
3. Enable the required APIs:
   - Cloud Run API
   - Cloud Functions API
   - Cloud Monitoring API
   - Cloud Logging API

## Task 1: Create a Cloud Run Function

### Steps:

1. In the Google Cloud Console, navigate to **Cloud Run** and click **Write a Function**
2. Configure the function:
   ```
   Service Name: helloworld
   Region: [your-preferred-region]
   Runtime: Node.js 22
   Authentication: Allow unauthenticated invocations
   ```
3. Under **Container(s), Volumes, Networking, Security**:
   - Set Execution environment to "second generation"
   - Set Maximum number of instances to 5
4. Click **Create** and then **Save and Redeploy**
5. Once deployed (indicated by a green checkmark), your function is ready

### Function Code

The default "Hello World" function code is included in the [index.js](./index.js) file in this repository.

### Generate Test Traffic

To generate test traffic to your function, use the [vegeta](https://github.com/tsenart/vegeta) load testing tool:

```bash
# Download vegeta
curl -LO 'https://github.com/tsenart/vegeta/releases/download/v12.12.0/vegeta_12.12.0_linux_386.tar.gz'

# Extract the tool
tar -xvzf vegeta_12.12.0_linux_386.tar.gz

# Get your Cloud Run URL
CLOUD_RUN_URL=$(gcloud run services describe helloworld --region=YOUR_REGION --format='value(status.url)')

# Generate traffic (200 requests per second for 5 minutes)
echo "GET $CLOUD_RUN_URL" | ./vegeta attack -duration=300s -rate=200 > results.bin
```

## Task 2: Create a Logs-Based Metric

1. In the Google Cloud Console, navigate to **Logging** > **Logs Explorer**
2. Filter logs to show only your Cloud Run function:
   - Select **Cloud Run Revision** > **helloWorld** from the resource dropdown
   - Click **Apply** and **Run query**
3. Create a logs-based metric:
   - Click **Actions** > **Create metric**
   - Change **Metric Type** to **Distribution**
   - Name: `CloudRunFunctionLatency-Logs`
   - Field name: `httpRequest.latency`
4. Click **Create metric**

## Task 3: Use Metrics Explorer

1. In the Google Cloud Console, navigate to **Monitoring** > **Metrics Explorer**
2. Configure your metric:
   - Click **Select a metric**
   - Filter for `CloudRunFunctionLatency-Logs`
   - Select **Cloud Run Revision** > **Logs-based metric** > **Logging/user/CloudRunFunctionLatency-Logs**
   - Click **Apply**
3. Change visualization:
   - Select **Stacked bar chart** from the widget type dropdown

Additional exploration options:
- Try different metrics like **Request Count**
- Experiment with different visualization types
- Modify aggregation methods (e.g., 95th percentile)

## Task 4: Create Custom Dashboard

1. Navigate to **Monitoring** > **Dashboards**
2. Click **Create Custom Dashboard**
3. Add widgets for different metrics:

   **Widget 1: Request Count**
   - Visualization: Stacked bar
   - Metric: Cloud Run Revision > Request Count

   **Widget 2: Request Latency Distribution**
   - Visualization: Heatmap
   - Metric: Cloud Run Revision > Logs-based metric > Logging/user/CloudRunFunctionLatency-Logs

   **Widget 3: Mean Request Latency**
   - Visualization: Line
   - Metric: Cloud Run Revision > Request_latency
   - Aggregation: Mean

   **Widget 4: CPU Allocation**
   - Visualization: Stacked bar
   - Metric: Cloud Run Revision > Container > Container CPU Allocation

4. Name your dashboard: "Cloud Run Function Custom Dashboard"

## Repository Contents

- [README.md](./README.md): This file, containing project documentation
- [index.js](./index.js): The Cloud Run function code
- [package.json](./package.json): Node.js package configuration
- [screenshots/](./screenshots/): Visual guides for the setup process
  - [function-creation.png](./screenshots/function-creation.png): Screenshot of function creation
  - [logs-metric.png](./screenshots/logs-metric.png): Screenshot of logs-based metric creation
  - [metrics-explorer.png](./screenshots/metrics-explorer.png): Screenshot of Metrics Explorer
  - [custom-dashboard.png](./screenshots/custom-dashboard.png): Screenshot of custom dashboard
- [traffic-generator.sh](./traffic-generator.sh): Script to generate test traffic

## References

- [Google Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Cloud Monitoring Documentation](https://cloud.google.com/monitoring/docs)
- [Cloud Logging Documentation](https://cloud.google.com/logging/docs)
- [Vegeta Load Testing Tool](https://github.com/tsenart/vegeta)
