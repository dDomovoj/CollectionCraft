# CollectionCraft

- CollectionView wrapping library

# Install

- Cocoapods:
```
pod 'CollectionCraft'
```

# Sourcery Build Phase:
```
unset SDKROOT
"$PODS_ROOT/Sourcery/bin/sourcery" --config "$PODS_ROOT/CollectionCraft/.sourcery/.sourcery.yml"
```
Also make sure to update `ProjectName`, `Target` and `Module` in `Pods/CollectionCraft/.sourcery/.sourcery.yml` file

Then marking `class SomeCell: CollectionViewCell, IReusableCell` with 
```
// sourcery: auto = "cell"
// sourcery: auto = "footer"
// sourcery: auto = "header"
```
will generate code in `$PODS_ROOT/../Generated/AutoReusableCell.generated.swift`
