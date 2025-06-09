1. jq '. | select(.event_type == "alert")' /path/to/logs/eve.json > alerts.json

2. Wzorki
- Precision = TP / (TP + FP)
- Recall = TP / (TP + FN)
- Accuracy = (TP + TN) / (TP + TN  + FP  + FN)