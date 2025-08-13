# 🎧 Spotify ETL Pipeline using AWS & Snowflake

This project is a **serverless ETL pipeline** that collects data from the **Spotify API**, processes it using **AWS Lambda**, stores it in **Amazon S3**, and automatically loads it into **Snowflake** using **Snowpipe** — making the data instantly available for analysis.

---

## 📊 Architecture Overview

📄 [View the Spotify ETL Pipeline Flowchart (PDF)](Spotify%20ETL%20Pipeline.pdf)

---

## 🛠 Tech Stack

- **Spotify API** – Source of playlist data  
- **AWS Lambda** – Serverless functions for extract and transform  
- **Amazon S3** – Raw and processed data storage  
- **Snowflake** – Cloud data warehouse  
- **Snowpipe** – Automated data loading into Snowflake tables  
- **Python** – Used for scripting Lambda functions  

---

## 🔄 How the Pipeline Works

1. **Extract**  
   A scheduled Lambda function connects to the Spotify API and pulls track data (e.g., song name, artist, album, duration). It saves the raw JSON response to an S3 bucket.

2. **Transform**  
   When new data is uploaded to S3, an S3 event triggers another Lambda function. This function cleans and reshapes the data into three structured CSV files: `songs`, `albums`, and `artists`. These files are then stored in a processed folder in S3.

3. **Load**  
   Snowpipe continuously monitors the processed folder in S3. When new CSV files are detected, it automatically loads them into corresponding tables in Snowflake — with relationships preserved via primary and foreign keys.

---

## 💡 Why This Project Matters

- It shows how raw API data can be turned into structured, query-ready tables in an automated way.
- Demonstrates key concepts of modern **data engineering**: event-driven processing, serverless architecture, and scalable cloud-based data warehousing.
- Can be extended to support other APIs or analytics use cases with minimal effort.

---

## 🗂 File Structure

```text
spotify-etl-pipeline/
├── extract_lambda.py         # Lambda function to fetch data from Spotify API
├── transform_lambda.py       # Lambda function to clean and structure data
├── snowflake_setup.sql       # SQL script to create Snowflake tables, stage, and pipes
├── Spotify ETL Pipeline.pdf  # Visual diagram of the ETL workflow
└── README.md                 # You're reading it!
```

## 📬 Contact

If you’re also exploring data engineering, cloud projects, or working with APIs — I’d love to connect!
