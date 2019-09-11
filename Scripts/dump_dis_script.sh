#!/bin/sh

python3 ./dump_dis.py > tmp.txt
python3 ./dump_dis_post.py tmp.txt
