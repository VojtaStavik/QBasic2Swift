#!/bin/bash
/usr/local/bin/QBasicSwift $1 > $1.swift
chmod +x $1.swift

$1.swift
