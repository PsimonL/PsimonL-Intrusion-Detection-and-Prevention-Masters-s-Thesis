import json
import pandas as pd
from datetime import datetime
 
print("Wczytywanie pliku ground_truth.csv...")
# Wczytanie danych referencyjnych (ground truth)
ground_truth = pd.read_csv('ground_truth.csv')
print("Poprawnie wczytano ground_truth.csv")
 
print("Wczytywanie pliku eve.json...")
# Wczytanie alertów z Suricaty
alerts = []
with open('datasets/signatures/eve.json') as f:
    for line in f:
        alert = json.loads(line)
        if alert.get('event_type') == 'alert':
            alerts.append(alert)
print("Wczytano plik eve.json")
 
# Inicjalizacja metryk
TP = 0
FP = 0
FN = 0
detected_attacks = set()
 
print("Start analizy...")
 
# Licznik postępu dla alertów
total_alerts = len(alerts)
print(f"Analiza alertów: 0 out of {total_alerts}", end="\r")
 
# Analiza True Positives (TP) i False Positives (FP)
for i, alert in enumerate(alerts, 1):
    print(f"Analiza alertów: {i} out of {total_alerts}", end="\r")
 
    alert_time = datetime.strptime(alert['timestamp'], '%Y-%m-%dT%H:%M:%S.%f%z').replace(tzinfo=None)
 
    alert_src_ip = alert.get('src_ip', '')
    alert_dst_ip = alert.get('dest_ip', '')
 
    detected = False
    for index, row in ground_truth.iterrows():
        start_time = datetime.strptime(row['timestamp_start'], '%Y-%m-%d %H:%M:%S')
        end_time = datetime.strptime(row['timestamp_end'], '%Y-%m-%d %H:%M:%S')
 
        if (start_time <= alert_time <= end_time and
            alert_src_ip == row['source_ip'] and
            alert_dst_ip == row['destination_ip']):
            TP += 1
            detected_attacks.add((row['timestamp_start'], row['timestamp_end'], row['attack_type']))
            detected = True
            break
 
    if not detected:
        FP += 1
 
# Licznik postępu dla ataków (False Negatives)
total_attacks = len(ground_truth)
print(f"\nAnaliza ataków: 0 out of {total_attacks}", end="\r")
 
for i, (index, row) in enumerate(ground_truth.iterrows(), 1):
    print(f"Analiza ataków: {i} out of {total_attacks}", end="\r")
 
    attack_key = (row['timestamp_start'], row['timestamp_end'], row['attack_type'])
    if attack_key not in detected_attacks:
        FN += 1
 
# Obliczenie statystyk
precision = TP / (TP + FP) if (TP + FP) > 0 else 0
recall = TP / (TP + FN) if (TP + FN) > 0 else 0
f1_score = 2 * (precision * recall) / (precision + recall) if (precision + recall) > 0 else 0
 
# Wyniki
print("\n\n=== Wyniki ===")
print(f"True Positives (TP): {TP}")
print(f"False Positives (FP): {FP}")
print(f"False Negatives (FN): {FN}")
print(f"Precyzja: {precision:.4f}")
print(f"Recall (czułość): {recall:.4f}")
print(f"F1-score: {f1_score:.4f}")