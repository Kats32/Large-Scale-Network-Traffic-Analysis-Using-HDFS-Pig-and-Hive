
-- Project: Large-Scale Network Traffic Analysis
-- Tools: HDFS, Apache Pig, Apache Hive
-- Table: network_flows

-- 1. Total number of processed network flows
SELECT COUNT(*) AS total_flows
FROM network_flows;


-- 2. Number of flows in each dataset
SELECT dataset, COUNT(*) AS total_flows
FROM network_flows
GROUP BY dataset
ORDER BY total_flows DESC;


-- 3. Distribution of traffic labels
SELECT label, COUNT(*) AS flow_count
FROM network_flows
GROUP BY label
ORDER BY flow_count DESC;


-- 4. Benign traffic versus attack traffic
SELECT
    CASE
        WHEN UPPER(TRIM(label)) = 'BENIGN' THEN 'BENIGN'
        ELSE 'ATTACK'
    END AS traffic_type,
    COUNT(*) AS flow_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM network_flows),
        2
    ) AS percentage
FROM network_flows
GROUP BY
    CASE
        WHEN UPPER(TRIM(label)) = 'BENIGN' THEN 'BENIGN'
        ELSE 'ATTACK'
    END;


-- 5. Top 10 destination ports
SELECT destination_port, COUNT(*) AS flow_count
FROM network_flows
GROUP BY destination_port
ORDER BY flow_count DESC
LIMIT 10;


-- 6. Average forward and backward packet counts
SELECT
    label,
    ROUND(AVG(total_fwd_packets), 2) AS avg_forward_packets,
    ROUND(AVG(total_backward_packets), 2) AS avg_backward_packets
FROM network_flows
GROUP BY label
ORDER BY label;


-- 7. Average flow duration by traffic label
SELECT
    label,
    ROUND(AVG(flow_duration), 2) AS avg_flow_duration
FROM network_flows
GROUP BY label
ORDER BY avg_flow_duration DESC;


-- 8. Average calculated packet rate by traffic label
-- Excludes records with zero or negative flow duration.
SELECT
    label,
    ROUND(
        AVG(
            (total_fwd_packets + total_backward_packets)
            / (flow_duration / 1000000.0)
        ),
        2
    ) AS avg_packets_per_sec
FROM network_flows
WHERE flow_duration > 0
GROUP BY label
ORDER BY avg_packets_per_sec DESC;


-- 9. Traffic labels within each dataset
SELECT
    dataset,
    label,
    COUNT(*) AS flow_count
FROM network_flows
GROUP BY dataset, label
ORDER BY dataset, flow_count DESC;
