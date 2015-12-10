//
// LineNumberTextView.swift
// LineNumberTextView
// https://github.com/raphaelhanneken/line-number-text-view
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Raphael Hanneken
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Cocoa

/// A NSTextView with a line number gutter attached to it.
public class LineNumberTextView: NSTextView {

  /// Holds the attached line number gutter.
  var lineNumberGutter: LineNumberGutter?


  override public func awakeFromNib() {
    // Get the enclosing scroll view
    guard let scrollView = self.enclosingScrollView else {
      fatalError("Unwrapping the text views scroll view failed!")
    }

    self.lineNumberGutter = LineNumberGutter(withTextView: self)

    scrollView.verticalRulerView  = self.lineNumberGutter
    scrollView.hasHorizontalRuler = false
    scrollView.hasVerticalRuler   = true
    scrollView.rulersVisible      = true

    self.addObservers()
  }

  /// Add observers to redraw the line number gutter, when necessary.
  internal func addObservers() {
    self.postsFrameChangedNotifications = true

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "drawGutter", name: NSViewFrameDidChangeNotification, object: self)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "drawGutter", name: NSTextDidChangeNotification, object: self)
  }

  /// Set needsDisplay of lineNumberGutter to true.
  internal func drawGutter() {
    if let lineNumberGutter = self.lineNumberGutter {
      lineNumberGutter.needsDisplay = true
    }
  }
}