import RPi.GPIO as GPIO
import time
import sys
#import os

FAN_PIN = 21
WAIT_TIME = 1
PWM_FREQ = 25

GPIO.setmode(GPIO.BCM)
GPIO.setup(FAN_PIN, GPIO.OUT, initial=GPIO.LOW)

fan=GPIO.PWM(FAN_PIN,PWM_FREQ)
fan.start(0);
i = 0

hyst = 1
tempSteps = [50, 70]
speedSteps = [0, 100]
cpuTempOld=0

try:
    while 1:
        fanSpeed=float(input("Fan Speed: "))
        fan.ChangeDutyCycle(fanSpeed)


except(KeyboardInterrupt):
    print("Fan ctrl interrupted by keyboard")
    GPIO.cleanup()
    sys.exit()
    
