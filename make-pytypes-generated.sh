GENERATED=./Sources/Objects/Generated

sourcery \
  --sources ./Sources/Objects \
  --templates $GENERATED/Data/modules.stencil \
  --output $GENERATED/Data/modules.txt

python3 $GENERATED/ModuleFactory.py > $GENERATED/ModuleFactory.swift
