sourcery \
  --sources ./Sources/Objects \
  --templates ./Scripts/dump_type_methods.stencil \
  --output ./Scripts/dump_type_methods_implemented.py

python3 ./Scripts/dump_type_methods.py > ./Scripts/dump_type_methods_result.txt
