buildAndRun:
	if [ -f ./gd ];then  rm gd ;fi
	nvcc main.cu  -g -G  $(NVCCFLAGS) -o gd -arch=sm_60  -Xptxas -v
	./gd

test:
	python3 comparison.py

analyze:
	python3 analysis.py
	