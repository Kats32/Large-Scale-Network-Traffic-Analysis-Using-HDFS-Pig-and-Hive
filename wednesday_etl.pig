raw_data = LOAD '/network_project/raw/Wednesday-workingHours.pcap_ISCX.csv'
    USING PigStorage(',');

without_header = FILTER raw_data BY
    $0 != 'Destination Port';

selected_data = FOREACH without_header GENERATE
    (int)$0 AS destination_port,
    (long)$1 AS flow_duration,
    (long)$2 AS total_fwd_packets,
    (long)$3 AS total_backward_packets,
    (double)$4 AS total_length_fwd_packets,
    (double)$5 AS total_length_bwd_packets,
    (double)$15 AS flow_packets_per_sec,
    (chararray)$78 AS label;

valid_data = FILTER selected_data BY
    destination_port IS NOT NULL
    AND flow_duration IS NOT NULL
    AND label IS NOT NULL;

STORE valid_data
INTO '/network_project/cleaned/wednesday'
USING PigStorage(',');
