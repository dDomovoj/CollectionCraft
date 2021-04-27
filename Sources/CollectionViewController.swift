//
//  CollectionViewController.swift
//  CollectionCraft
//
//  Created by dDomovoj on 9/16/19.
//

import UIKit

class InvalidationContext: UICollectionViewFlowLayoutInvalidationContext {

  override var invalidateEverything: Bool { true }

}

open class CollectionViewController: UIViewController {

  public typealias Section = CollectionSection

  private lazy var collectionViewLayout = self.collectionViewLayoutInstance()
  public var collectionView: CollectionView { _collectionView ?? preconditionFailure() }
  public var source: CollectionSource { _source ?? preconditionFailure() }

  private var _collectionView: CollectionView?
  private lazy var _source: CollectionSource? = self.collectionSourceInstance()

  // MARK: - Init

  required override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    _collectionView = CollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    _collectionView = CollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
  }

  // MARK: - Lifecycle

  override open func loadView() {
    super.loadView()
    view.backgroundColor = .clear
    collectionView.backgroundColor = .clear
    collectionView.alwaysBounceVertical = true
    collectionView.contentInsetAdjustmentBehavior = .never
    view.addSubview(collectionView)
  }

  override open func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateContentInset()
    collectionView.frame = view.bounds
    if collectionView.frame.size != view.bounds.size {
      invalidateLayout()
    }
  }

  override open func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()
    updateContentInset()
  }

  override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { [weak self] _ in
      self?.invalidateLayout()
    }, completion: nil)
  }

  // MARK: - Public

  open func collectionSourceInstance() -> CollectionSource {
    CollectionSource(collectionView: collectionView)
  }

  open func collectionViewLayoutInstance() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    return layout
  }

  open func updateContentInset() {
    collectionView.contentInset = view.safeAreaInsets
  }

  public func invalidateLayout() {
    collectionViewLayout.invalidateLayout(with: InvalidationContext())
  }

}
