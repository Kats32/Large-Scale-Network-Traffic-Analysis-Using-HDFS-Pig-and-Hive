-- Load raw CICIDS2017 PortScan data from HDFS
raw_data = LOAD '/network_project/raw/Friday-WorkingHours-Afternoon-PortScan.pcap_ISCX.csv'
    USING PigStorage(',')
    AS (
        destination_port:chararray,
        flow_duration:chararray,
        total_fwd_packets:chararray,
        total_backward_packets:chararray,
        total_length_fwd_packets:chararray,
        total_length_bwd_packets:chararray,
        fwd_packet_length_max:chararray,
        fwd_packet_length_min:chararray,
        fwd_packet_length_mean:chararray,
        fwd_packet_length_std:chararray,
        bwd_packet_length_max:chararray,
        bwd_packet_length_min:chararray,
        bwd_packet_length_mean:chararray,
        bwd_packet_length_std:chararray,
        flow_bytes_per_sec:chararray,
        flow_packets_per_sec:chararray,
        flow_iat_mean:chararray,
        flow_iat_std:chararray,
        flow_iat_max:chararray,
        flow_iat_min:chararray,
        fwd_iat_total:chararray,
        fwd_iat_mean:chararray,
        fwd_iat_std:chararray,
        fwd_iat_max:chararray,
        fwd_iat_min:chararray,
        bwd_iat_total:chararray,
        bwd_iat_mean:chararray,
        bwd_iat_std:chararray,
        bwd_iat_max:chararray,
        bwd_iat_min:chararray,
        fwd_psh_flags:chararray,
        bwd_psh_flags:chararray,
        fwd_urg_flags:chararray,
        bwd_urg_flags:chararray,
        fwd_header_length:chararray,
        bwd_header_length:chararray,
        fwd_packets_per_sec:chararray,
        bwd_packets_per_sec:chararray,
        min_packet_length:chararray,
        max_packet_length:chararray,
        packet_length_mean:chararray,
        packet_length_std:chararray,
        packet_length_variance:chararray,
        fin_flag_count:chararray,
        syn_flag_count:chararray,
        rst_flag_count:chararray,
        psh_flag_count:chararray,
        ack_flag_count:chararray,
        urg_flag_count:chararray,
        cwe_flag_count:chararray,
        ece_flag_count:chararray,
        down_up_ratio:chararray,
        average_packet_size:chararray,
        avg_fwd_segment_size:chararray,
        avg_bwd_segment_size:chararray,
        fwd_header_length_2:chararray,
        fwd_avg_bytes_bulk:chararray,
        fwd_avg_packets_bulk:chararray,
        fwd_avg_bulk_rate:chararray,
        bwd_avg_bytes_bulk:chararray,
        bwd_avg_packets_bulk:chararray,
        bwd_avg_bulk_rate:chararray,
        subflow_fwd_packets:chararray,
        subflow_fwd_bytes:chararray,
        subflow_bwd_packets:chararray,
        subflow_bwd_bytes:chararray,
        init_win_bytes_forward:chararray,
        init_win_bytes_backward:chararray,
        act_data_pkt_fwd:chararray,
        min_seg_size_forward:chararray,
        active_mean:chararray,
        active_std:chararray,
        active_max:chararray,
        active_min:chararray,
        idle_mean:chararray,
        idle_std:chararray,
        idle_max:chararray,
        idle_min:chararray,
        label:chararray
    );

-- Remove the CSV header
without_header = FILTER raw_data BY destination_port != 'Destination Port';

-- Select useful fields and convert numeric values
selected_data = FOREACH without_header GENERATE
    (int)destination_port AS destination_port,
    (long)flow_duration AS flow_duration,
    (long)total_fwd_packets AS total_fwd_packets,
    (long)total_backward_packets AS total_backward_packets,
    (double)total_length_fwd_packets AS total_length_fwd_packets,
    (double)total_length_bwd_packets AS total_length_bwd_packets,
    (double)flow_packets_per_sec AS flow_packets_per_sec,
    label AS label;

-- Remove records with missing important values
valid_data = FILTER selected_data BY
    destination_port IS NOT NULL AND
    flow_duration IS NOT NULL AND
    label IS NOT NULL;

-- Remove duplicate records
cleaned_data = DISTINCT valid_data;

-- Store cleaned data in HDFS
STORE cleaned_data INTO '/network_project/cleaned'
    USING PigStorage(',');
