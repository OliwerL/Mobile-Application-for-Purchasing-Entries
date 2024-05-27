import cv2
from pyzbar import pyzbar
import time

def read_qr_code(frame, last_seen_times, display_time_interval):
    current_time = time.time()
    qr_codes = pyzbar.decode(frame)
    visible_qr_codes = set()

    for qr_code in qr_codes:
        qr_data = qr_code.data.decode('utf-8')
        visible_qr_codes.add(qr_data)

        if qr_data not in last_seen_times or (current_time - last_seen_times[qr_data]) > display_time_interval:
            print(f"QR Code Data: {qr_data}")
            last_seen_times[qr_data] = current_time

        x, y, w, h = qr_code.rect
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
        cv2.putText(frame, qr_data, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

    # Usuwanie kodów, które nie były widoczne przez więcej niż 2 sekundy
    to_remove = [key for key, value in last_seen_times.items() if (current_time - value) > display_time_interval]
    for key in to_remove:
        del last_seen_times[key]

    return frame

def main():
    cap = cv2.VideoCapture(1)
    last_seen_times = {}
    display_time_interval = 2  # Czas w sekundach

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        frame = read_qr_code(frame, last_seen_times, display_time_interval)
        cv2.imshow('QR Code Scanner', frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    main()
