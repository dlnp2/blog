python setup.py build_ext -i
gcc $(python-config --cflags) $(python-config --ldflags) -L. -lcybridge -Wl,-rpath,. main.c
