#!/bin/bash
/usr/local/bin/QBasic2Swift $1 > $1.swift
chmod +x $1.swift

$1.swift
