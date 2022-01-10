import 'dart:math';

class IntervalD implements Comparable<IntervalD> {
  final int min;
  final int max;

  IntervalD(
    this.min,
    this.max,
  ) : assert(min <= max);

  @override
  String toString() {
    return '[$min, $max]';
  }

  // does this interval intersect that one?
  bool intersects(IntervalD that) {
    if (that.max <= this.min) return false;
    if (this.max <= that.min) return false;
    return true;
  }

  // does this interval a intersect b?
  bool contains(int x) {
    return (min <= x) && (x <= max);
  }

  int compareTo(IntervalD that) {
    if (this.min < that.min)
      return -1;
    else if (this.min > that.min)
      return 1;
    else if (this.max < that.max)
      return -1;
    else if (this.max > that.max)
      return 1;
    else
      return 0;
  }
}

class Node<T> {
  IntervalD interval; // key
  T value; // associated data
  Node? left, right; // left and right subtrees
  int N; // size of subtree rooted at this node
  int max; // max endpoint in subtree rooted at this node
  Node(this.interval, this.value)
      : N = 1,
        max = interval.max;
}

class IntervalSt<T> {
  Node? root;

  /*
   * BST search
   */
  bool contains(IntervalD interval) {
    return (get(interval) != null);
  }

  // return value associated with the given key
  // if no such value, return null
  T? get(IntervalD interval) {
    return _get(root, interval);
  }

  T? _get(Node? x, IntervalD interval) {
    if (x == null) return null;
    int cmp = interval.compareTo(x.interval);
    if (cmp < 0)
      return _get(x.left, interval);
    else if (cmp > 0)
      return _get(x.right, interval);
    else
      return x.value;
  }

  void put(IntervalD interval, T value) {
    if (contains(interval)) {
      remove(interval);
    }
    root = _randomizedInsert(root, interval, value);
  }

  // make new node the root with uniform probability
  Node? _randomizedInsert(Node? x, IntervalD interval, T value) {
    var random = Random();
    if (x == null) return Node(interval, value);
    if (random.nextDouble() * _size(x) < 1.0)
      return _rootInsert(x, interval, value);
    int cmp = interval.compareTo(x.interval);
    if (cmp < 0)
      x.left = _randomizedInsert(x.left, interval, value);
    else
      x.right = _randomizedInsert(x.right, interval, value);
    _fix(x);
    return x;
  }

  Node? _rootInsert(Node? x, IntervalD interval, T value) {
    if (x == null) return Node(interval, value);
    int cmp = interval.compareTo(x.interval);
    if (cmp < 0) {
      x.left = _rootInsert(x.left, interval, value);
      x = _rotR(x);
    } else {
      x.right = _rootInsert(x.right, interval, value);
      x = _rotL(x);
    }
    return x;
  }

  /*
   * deletion
   */

  // remove and return value associated with given interval;
  // if no such interval exists return null
  T? remove(IntervalD interval) {
    T? value = get(interval);
    root = _remove(root, interval);
    return value;
  }

  Node? _remove(Node? h, IntervalD interval) {
    if (h == null) return null;
    int cmp = interval.compareTo(h.interval);
    if (cmp < 0)
      h.left = _remove(h.left, interval);
    else if (cmp > 0)
      h.right = _remove(h.right, interval);
    else
      h = _joinLR(h.left, h.right);
    _fix(h);
    return h;
  }

  Node? _joinLR(Node? a, Node? b) {
    if (a == null) return b;
    if (b == null) return a;
    var random = Random();
    if (random.nextDouble() * (_size(a) + _size(b)) < _size(a)) {
      a.right = _joinLR(a.right, b);
      _fix(a);
      return a;
    } else {
      b.left = _joinLR(a, b.left);
      _fix(b);
      return b;
    }
  }

  /*
   * IntervalD searching
   */
  // return an interval in data structure that intersects the given inteval;
  // return null if no such interval exists
  // running time is proportional to log N
  IntervalD? search(IntervalD interval) {
    return _search(root, interval);
  }

  // look in subtree rooted at x
  IntervalD? _search(Node? x, IntervalD interval) {
    while (x != null) {
      if (interval.intersects(x.interval))
        return x.interval;
      else if (x.left == null)
        x = x.right;
      else if (x.left!.max < interval.min)
        x = x.right;
      else
        x = x.left;
    }
    return null;
  }

  Iterable<IntervalD> searchAll(IntervalD interval) {
    List<IntervalD> list = [];
    searchAllWithNode(root, interval, list);
    return list;
  }

  Iterable<Node> searchAllOverlappingNodes(IntervalD interval) {
    List<Node> list = [];
    searchAllOverlappingNodesWithNode(root, interval, list);
    return list;
  }

  // look in subtree rooted at x
  bool searchAllOverlappingNodesWithNode(Node? x, IntervalD interval, List<Node> list) {
    bool found1 = false;
    bool found2 = false;
    bool found3 = false;
    if (x == null) return false;
    if (interval.intersects(x.interval)) {
      list.add(x);
      found1 = true;
    }
    if (x.left != null && x.left!.max >= interval.min)
      found2 = searchAllOverlappingNodesWithNode(x.left, interval, list);
    if (found2 || x.left == null || x.left!.max < interval.min)
      found3 = searchAllOverlappingNodesWithNode(x.right, interval, list);
    return found1 || found2 || found3;
  }

  // look in subtree rooted at x
  bool searchAllWithNode(Node? x, IntervalD interval, List<IntervalD> list) {
    bool found1 = false;
    bool found2 = false;
    bool found3 = false;
    if (x == null) return false;
    if (interval.intersects(x.interval)) {
      list.add(x.interval);
      found1 = true;
    }
    if (x.left != null && x.left!.max >= interval.min)
      found2 = searchAllWithNode(x.left, interval, list);
    if (found2 || x.left == null || x.left!.max < interval.min)
      found3 = searchAllWithNode(x.right, interval, list);
    return found1 || found2 || found3;
  }

  /*
   * useful binary tree functions
   */
  int size() {
    return _size(root);
  }

  int _size(Node? x) {
    if (x == null)
      return 0;
    else
      return x.N;
  }

  // height of tree (empty tree height = 0)
  int height() {
    return _height(root);
  }

  int _height(Node? x) {
    if (x == null) return 0;
    return 1 + max(_height(x.left), _height(x.right));
  }

  /* 
    helper BST functions
   */
  void _fix(Node? x) {
    if (x == null) return;
    x.N = 1 + _size(x.left) + _size(x.right);
    x.max = _max3(x.interval.max, _max(x.left), _max(x.right));
  }

  int _max(Node? x) {
    if (x == null) return 2 ^ 63 - 1;
    return x.max;
  }

  // precondition: a is not null
  int _max3(int a, int b, int c) {
    return max(a, max(b, c));
  }

  // right rotate
  Node _rotR(Node h) {
    Node x = h.left!;
    h.left = x.right;
    x.right = h;
    _fix(h);
    _fix(x);
    return x;
  }

  // left rotate
  Node _rotL(Node h) {
    Node x = h.right!;
    h.right = x.left;
    x.left = h;
    _fix(h);
    _fix(x);
    return x;
  }

  /*
   * Debugging functions that test the integrity of the tree
   */
  // check integrity of subtree count fields
  bool check() {
    return _checkCount() && _checkMax();
  }

  // check integrity of count fields
  bool _checkCount() {
    return _checkCountWithNode(root);
  }

  bool _checkCountWithNode(Node? x) {
    if (x == null) return true;
    return _checkCountWithNode(x.left) &&
        _checkCountWithNode(x.right) &&
        (x.N == 1 + _size(x.left) + _size(x.right));
  }

  bool _checkMax() {
    return _checkMaxWithNode(root);
  }

  bool _checkMaxWithNode(Node? x) {
    if (x == null) return true;
    return x.max == _max3(x.interval.max, _max(x.left), _max(x.right));
  }
}
