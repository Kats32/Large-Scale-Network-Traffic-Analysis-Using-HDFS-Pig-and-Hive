# Large-Scale Network Traffic Analysis Using HDFS, Apache Pig, and Apache Hive

## 1. Project Overview

This project implements a batch-processing pipeline for large-scale network traffic analysis using **Hadoop HDFS, Apache Pig, and Apache Hive**. The CICIDS2017 intrusion detection dataset is processed to clean network flow records, organize the processed data, and analyze benign and malicious network traffic.

The project demonstrates how big data technologies can be integrated to process millions of network flow records and extract useful insights about network behavior and attack patterns.

## 2. Objectives

- Store large network traffic datasets using Hadoop Distributed File System (HDFS).
- Clean and transform raw CSV data using Apache Pig.
- Load and organize processed network traffic data in Apache Hive.
- Analyze traffic distributions, attack categories, packet behavior, and destination ports.
- Generate graphs to visualize the analytical results.

## 3. Technologies Used

| Technology          | Purpose                                         |
| ------------------- | ----------------------------------------------- |
| Apache Hadoop 3.3.6 | Distributed storage and HDFS operations         |
| Apache Pig 0.18.0   | Data cleaning and ETL processing                |
| Apache Hive 4.0.1   | SQL-based analysis and querying                 |
| Beeline             | Connecting to HiveServer2 and executing queries |
| Python              | Generating visualizations                       |
| Matplotlib / Pandas | Plotting and result analysis                    |
| Ubuntu on WSL       | Development and execution environment           |
| CICIDS2017          | Network traffic dataset                         |

## 4. Dataset

The project uses the **CICIDS2017 dataset**, which contains labeled network traffic records representing benign traffic and different types of attacks.

Official dataset source:

https://www.unb.ca/cic/datasets/ids-2017.html

The project processes eight CSV datasets:

- Monday
- Tuesday
- Wednesday
- Thursday Infiltration
- Thursday Web Attacks
- Friday Morning
- Friday DDoS
- Friday PortScan

The raw dataset is not included in this repository because of its large size. Download it from the official source and extract the CSV files before running the pipeline.

## 5. Project Architecture

```text
CICIDS2017 CSV Files
        |
        v
   HDFS Raw Storage
        |
        v
 Apache Pig ETL Processing
        |
        v
  HDFS Cleaned Data
        |
        v
 Apache Hive Tables
        |
        v
  SQL-Based Analysis
        |
        v
 Results and Graphs
```

### Data Processing Workflow

1. **Data ingestion:** Store the raw CSV files in HDFS.
2. **Data cleaning:** Use Apache Pig to remove headers, select relevant attributes, convert data types, and filter records with missing required values.
3. **Data storage:** Save cleaned output in HDFS.
4. **Data organization:** Load the cleaned datasets into the Hive database `network_analysis`, using dataset partitions.
5. **Data analysis:** Execute Hive queries to analyze traffic labels, flow counts, packet behavior, flow duration, and destination ports.
6. **Visualization:** Use Python to generate graphs from the analysis results.

## 6. Repository Structure

```text
bigdata_project/
├── hive/
│   └── network_analysis.hql
├── visualization/
│   └── Python visualization scripts
├── project_graphs/
│   └── Generated analysis graphs
├── network_clean.pig
├── friday_morning.pig
├── monday.pig
├── portscan_clean.pig
├── thursday_infilteration_etl.pig
├── thursday_webattacks_etl.pig
├── tuesday_etl.pig
├── wednesday_etl.pig
├── .gitignore
└── README.md
```

## 7. Requirements

Install or configure the following software in a compatible Linux environment:

- Java
- Hadoop
- Apache Pig
- Apache Hive
- Python 3
- Python packages: `pandas` and `matplotlib`
- Git

The versions used during development were Hadoop 3.3.6, Apache Pig 0.18.0, and Apache Hive 4.0.1.

## 8. How to Run the Project

### Step 1: Clone the repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd <YOUR_REPOSITORY_FOLDER>
```

Replace the placeholders with your actual GitHub repository URL and folder name.

### Step 2: Start Hadoop

Start HDFS and YARN using the configuration of your Hadoop environment.

```bash
start-dfs.sh
start-yarn.sh
```

Verify HDFS is running:

```bash
jps
hdfs dfs -ls /
```

### Step 3: Upload the raw dataset to HDFS

After downloading and extracting the CICIDS2017 CSV files, create the raw-data directory:

```bash
hdfs dfs -mkdir -p /network_project/raw
```

Upload the CSV files:

```bash
hdfs dfs -put /path/to/your/csv/files/*.csv /network_project/raw/
```

Replace `/path/to/your/csv/files/` with the actual directory containing the extracted CSV files.

### Step 4: Run Apache Pig ETL scripts

Run the relevant Pig scripts from the project directory. For example:

```bash
pig -x mapreduce network_clean.pig
```

Execute the remaining dataset-specific scripts as appropriate for their input and output paths.

**Important:** Ensure that each script's HDFS input paths, output paths, and schema match your environment. Do not rerun a script that writes to an existing output directory without handling that directory first.

### Step 5: Start Hive services

Start the Hive Metastore and HiveServer2 if they are not already running, using your local Hive configuration.

Connect using Beeline:

```bash
beeline -u jdbc:hive2://localhost:10000/default
```

### Step 6: Create and query the Hive database

If the database and table have already been created, select the existing database:

```sql
USE network_analysis;
DESCRIBE network_flows;
```

Execute the project's Hive analysis queries:

```bash
beeline -u jdbc:hive2://localhost:10000/network_analysis \
  -f hive/network_analysis.hql
```

Ensure that the HQL file exists at the specified path and that its queries match the table schema.

### Step 7: Generate visualizations

Install the Python dependencies:

```bash
python3 -m pip install pandas matplotlib
```

Run the visualization script available in the `visualization/` directory. For example, if the script is named `generate_graphs.py`:

```bash
python3 visualization/generate_graphs.py
```

Update the command if your actual script has a different filename. Make sure the script points to the correct local result files.

## 9. Analysis Performed

The project performs the following analyses:

- **Traffic label distribution:** Counts of benign traffic and individual attack categories.
- **Benign versus attack traffic:** Comparison of benign and malicious flow records.
- **Dataset-wise flow counts:** Comparison of the number of records in each CSV dataset.
- **Attack distribution by dataset:** Identifies which attack categories occur in each dataset.
- **Top destination ports:** Identifies frequently occurring destination ports.
- **Average flow duration:** Compares flow durations across traffic labels.
- **Packet behavior:** Compares forward and backward packet counts.
- **Packet rate:** Analyzes packet rates by traffic label, excluding records with non-positive flow duration where required.

## 10. Results

The completed pipeline processed **2,748,871 network flow records** across the eight datasets.

| Metric                |    Result |
| --------------------- | --------: |
| Total processed flows | 2,748,871 |
| Benign flows          | 2,259,412 |
| Attack flows          |   489,459 |
| Benign traffic        |    82.19% |
| Attack traffic        |    17.81% |
| Number of datasets    |         8 |

The analysis identified multiple traffic categories, including DDoS, DoS, PortScan, Bot, brute-force attacks, web attacks, and infiltration.

The generated graphs are available in the `project_graphs/` directory.

These results describe the processed dataset and should not be interpreted as real-time detection or a production intrusion prevention system.

## 11. Limitations

- The implementation uses batch processing rather than real-time streaming.
- The results depend on the quality and coverage of the CICIDS2017 dataset.
- Rare attack categories contain relatively few records, so their statistical summaries should be interpreted cautiously.
- The development environment is a local WSL setup, not a production multi-node Hadoop cluster.
- The project performs data processing and descriptive analysis; it does not train a machine-learning intrusion detection model.

## 12. Future Enhancements

- Integrate additional network traffic datasets.
- Add automated report generation.
- Compare performance across different data volumes.
- Integrate a machine-learning model for attack classification.
- Extend the pipeline with streaming technologies for real-time analysis.

## 13. Team Information

**Institution:** Indian Institute of Information Technology Kottayam (IIIT Kottayam)

**Course:** CSE412 — Big Data & Large-Scale Computing

**Project Title:** Large-Scale Network Traffic Analysis Using HDFS, Apache Pig, and Apache Hive

**Team Members:**

- Member 1: M.Kavya
- Member 2: T.Srija
- Member 3: K.Saikrishna

## 14. References

1. Canadian Institute for Cybersecurity, _CICIDS2017 Dataset_. https://www.unb.ca/cic/datasets/ids-2017.html
2. Apache Hadoop Documentation. https://hadoop.apache.org/docs/
3. Apache Pig Documentation. https://pig.apache.org/docs/
4. Apache Hive Documentation. https://hive.apache.org/

---

