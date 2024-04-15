from pyzbar.pyzbar import decode
import cv2

image = cv2.imread('qr.png')

gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

decoded_objects = decode(gray_image)
for obj in decoded_objects:
    print("Type:", obj.type)
    print("Data:", obj.data.decode('utf-8'))
