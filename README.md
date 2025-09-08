Overview
This project implements a fire and gas monitoring system with motor control using Verilog HDL. The system consists of several modules:
Monitoring Module: The top-level module that instantiates other modules and provides outputs for buzzer, LEDs, 7-segment display, and motor control.
Final Module: Handles logic for buzzer, LEDs, and counter based on inputs from fire, gas, and IR sensors.
Segment Display Module: Drives a 4-digit 7-segment display to show the count value.
Segment Encoder Module: Encodes digit values to 7-segment display codes.
Motor Module: Controls a motor based on the fire sensor input.
Features
Monitors fire, gas, and IR sensor inputs
Drives a buzzer and LEDs based on sensor inputs
Displays count value on a 4-digit 7-segment display
Controls a motor based on fire sensor input
Provides reset functionality for counter and LED
Module Description
Monitoring Module
Instantiates Final, Motor, and Segment Display modules
Provides outputs for buzzer, LEDs, 7-segment display, and motor control
Final Module
Handles logic for buzzer, LEDs, and counter based on sensor inputs
Counts up when IR sensor is low and resets when reset input is high
Segment Display Module
Drives a 4-digit 7-segment display to show the count value
Uses a multiplexer to switch between digits
Segment Encoder Module
Encodes digit values to 7-segment display codes
Motor Module
Controls a motor based on fire sensor input
Stops motor when fire is detected and runs it forward otherwise
Usage
Instantiate the Monitoring module in your top-level design.
Provide inputs for fire, gas, IR sensors, and reset signals.
Connect outputs for buzzer, LEDs, 7-segment display, and motor control.
Notes
This code assumes a 50MHz clock frequency.
The motor control logic is designed to stop the motor when fire is detected and run it forward otherwise.
The 7-segment display shows the count value, which increments when the IR sensor is low.
