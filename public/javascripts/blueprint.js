/*  Blueprint version 0.4 (c) 2007 Tobie Langel (http://tobielangel.com)
 *
 *  Blueprint is freely distributable under the terms of an MIT-style license.
 *  Requires Prototype v1.5.2_pre0 (http://www.prototypejs.org/)
 *
/*--------------------------------------------------------------------------*/

var Blueprint = {
  Version: '0.4',
  // PrototypeVersion: '1.5.2_pre0',
  Basic: {
    addObservers: function() {
      this.handlers.each(function(handler) {
        var callback = handler.value;
        handler = handler.key.split(':');
        if(handler.length > 1) this[handler[0]].observe(handler[1], callback);
        else this['element'].observe(handler[0], callback);
      }.bind(this));
    },

    removeObservers: function() {
      this.handlers.each(function(handler) {
        var callback = handler.value;
        handler = handler.key.split(':');
        if(handler.length > 1) this[handler[0]].stopObserving(handler[1], callback);
        else this['element'].stopObserving(handler[0], callback);
      }.bind(this));
    },

    event: function() {
      var args = $A(arguments), name = args.shift();
      name = 'on' + name.charAt(0).toUpperCase() + name.substring(1);
      if(this.options[name]) this.options[name].apply(null, args);
    }
  }
}

// if(Blueprint.PrototypeVersion != Prototype.Version)
//   throw new Error('Blueprint v0.4 is targeted at Prototype v1.5.2_pre0.');

var _ = Prototype.K;

$w('parseInt parseFloat').each(function(method) {
  String.prototype[method] = window[method].methodize();
  // Number.prototype[method] = window[method].methodize();
});

/*--------------------------------------------------------------------------*/
// Original idea by beppu (http://beppu.lbox.org)

var Aspect = {
  before: function(methodName, advice) {
    var original = this[methodName];
    this._storeOriginalMethod(methodName);
    this[methodName] = function() {
      advice.apply(this, arguments);
      return original.apply(this, arguments);
    }
  },

  after: function(methodName, advice) {
    var original = this[methodName];
    this._storeOriginalMethod(methodName);
    this[methodName] = function() {
      var returnedValue = original.apply(this, arguments);
      return advice.apply(this, [returnedValue].concat($A(arguments)));
    }
  },

  around: function(methodName, advice) {
    this._storeOriginalMethod(methodName);
    this[methodName] = this[methodName].wrap(advice);
  },

  rollback: function(methodName, index) {
    if(!(this.originalMethods && this.originalMethods[methodName])) return;
    index = (index || 1);
    this[methodName] = this.originalMethods[methodName].splice(0, index).last() || this[methodName];
  },

  restoreOriginalMethod: function() {
    if(!this.originalMethods) return;
    $A(arguments).each(function(methodName) {
      if(!this.originalMethods[methodName]) return;
      this[methodName] = this.originalMethods[methodName].last() || this[methodName];
      this.originalMethods[methodName].clear();
    }.bind(this));
  },

  _storeOriginalMethod: function(methodName) {
    if(!this.originalMethods) this.originalMethods = {};
    if(!this.originalMethods.hasOwnProperty(methodName))
      this.originalMethods[methodName] = [];
    this.originalMethods[methodName].unshift(this[methodName]);
  }
};

/*--------------------------------------------------------------------------*/
Element.HiddenClassName = 'hidden'

Element.addMethods({
  visible: function(element, byClassName) {
    element = $(element);
    if(byClassName)
      return !element.hasClassName(Element.HiddenClassName);
    return element.style.display != 'none';
  },

  toggle: function(element, byClassName) {
    element = $(element);
    Element[Element.visible(element, byClassName) ? 'hide' : 'show'](element, byClassName);
    return element;
  },

  hide: function(element, byClassName) {
    element = $(element);
    if(byClassName)
      return element.addClassName(Element.HiddenClassName);
    element.style.display = 'none';
    return element;
  },

  show: function(element, byClassName) {
    element = $(element);
    if(byClassName)
      return element.removeClassName(Element.HiddenClassName);
    element.style.display = '';
    return element;
  },

  processing: function(element) {
    element = $(element);

    options = Object.extend({
      text: _('processing'),
      interval: 0.3
    }, arguments[1] || {});

    element._innerHTML = element.innerHTML;
    element.update(options.text);
    element._periodicalExecuter = new PeriodicalExecuter(function(text, length){
      var html = this.innerHTML;
      this.update((html.length - length) > 2 ? text : html + '.');
    }.bind(element, options.text, options.text.length), options.interval);
    return element;
  },

  stopProcessing: function(element, text) {
    element = $(element);
    element._periodicalExecuter.stop();
    element.update(text ? text : element._innerHTML);
    element._innerHTML = element._periodicalExecuter = undefined;
    return element;
  },

  appendText: function(element, text) {
    element = $(element);
    text = String.interpret(text);
    element.appendChild(document.createTextNode(text));
    return element;
  },

  getElementByTagName: function(element, tagName, index) {
    return $(element.getElementsByTagName(tagName)[index || 0]);
  }
});

Element.addMethods($w('INPUT SELECT TEXTAREA'), {
  getForm: function(element) {
    return $(element.form) || $(element).up('form');
  },

  getLabel: function(element) {
    element = $(element);
    var label, id;
    if (label = element.up('label')) return label;
    if (id = element.readAttribute('id'))
      return element.getForm().down('label[for=' + id + ']');
  }
});

/*--------------------------------------------------------------------------*/
try {
  document.execCommand("BackgroundImageCache", false, true);
} catch(e) {}

var CSS = {
  // inspired by http://yuiblog.com/blog/2007/06/07/style/
  addRule: function(css, backwardCompatibility) {
    if (backwardCompatibility) css = css + '{' + backwardCompatibility + '}';
    var style = new Element('style', {type: 'text/css', media: 'screen'});
    $(document.getElementsByTagName('head')[0]).insert(style);
    if (style.styleSheet) style.styleSheet.cssText = css;
    else style.appendChild(document.createTextNode(css));
  },

  findRule: function(selector) {
    var cssText, cssRules;
    $A(document.styleSheets).reverse().each(function(styleSheet) {
      if (styleSheet.cssRules) cssRules = styleSheet.cssRules;
      else if (styleSheet.rules) cssRules = styleSheet.rules;
      $A(cssRules).reverse().each(function(rule) {
        if (selector == rule.selectorText) {
          cssText = rule.style.cssText;
          throw $break;
        }
      });
      if (cssText) throw $break;
    });
    return cssText;
  }
};

/*--------------------------------------------------------------------------*/
// based on work by Dan Webb, Matthias Miller, Dean Edwards and John Resig.

Object.extend(Event, {
  _domReady : function() {
    if (arguments.callee.done) return;
    arguments.callee.done = true;

    if (Event._timer) clearInterval(Event._timer);

    Event._readyCallbacks.each(function(f) { f() });
    Event._readyCallbacks = null;

  },

  onReady : function(f) {
    if (!this._readyCallbacks) {
      var domReady = this._domReady;

      if (domReady.done) return f();

      if (document.addEventListener) {
        if (Prototype.Browser.WebKit) {
          this._timer = (function() {
            if (/loaded|complete/.test(document.readyState)) domReady();
          }).defer();
        } else document.addEventListener("DOMContentLoaded", domReady, false);
      } else if(Prototype.Browser.IE) {
        var dummy = location.protocol == "https:" ?  "https://javascript:void(0)" : "javascript:void(0)";
        document.write("<script id=__ie_onload defer src='" + dummy + "'><\/script>");
        document.getElementById("__ie_onload").onreadystatechange = function() {
          if (this.readyState == "complete") domReady();
        };
      }
      Event.observe(window, 'load', domReady);
      Event._readyCallbacks =  [];
    }
    Event._readyCallbacks.push(f);
  }
});

/*--------------------------------------------------------------------------*/
// Toggler
// Copyright (c) 2007 Tobie Langel (http://tobielangel.com) & Gnolia Systems LP.

var Toggler = Class.create();
Object.extend(Object.extend(Toggler.prototype, Blueprint.Basic), {
  initialize: function(toggler, element) {
    this.options = arguments[2] || {};
    this.toggler = $(toggler);
    this.element = $(element);
    this.originalText = this.toggler.innerHTML;

    this.handlers = $H({
      'toggler:click': this.toggle.bindAsEventListener(this)
    });
    this.addObservers();
    this.event('initialize', this);
  },

  toggle: function(event) {
    if(this.options.altText)
      this.toggler.update(this.toggler.innerHTML == this.options.altText
        ? this.originalText : this.options.altText);
    this.element.visible(true) ? this.hide() : this.show();
    Event.stop(event);
    this.event('toggle', this);
  },

  hide: function() {
    if(this.options.className) this.toggler.removeClassName(this.options.className)
    this.element.hide(true);
    this.event('hide', this);
  },

  show: function() {
    if(this.options.className) this.toggler.addClassName(this.options.className)
    this.element.show(true);
    this.event('show', this);
  }
});

/*--------------------------------------------------------------------------*/
// ContextMenu
// Copyright (c) 2007 Tobie Langel (http://tobielangel.com) & Gnolia Systems LP.

Object.extend(Toggler.prototype, Aspect);

var ContextMenu = Class.create();
Object.extend(ContextMenu.prototype, Toggler.prototype);
ContextMenu.selected = {};

ContextMenu.prototype.around('initialize', function(uber, toggler, element) {
  var options = Object.extend({
    className: 'selected-menu',
    scope: 'global'
  }, arguments[3] || {});
  uber(toggler, element, options);
  this.element.hide(true);
  this.scope = this.options.scope;
  if(!ContextMenu.selected[this.scope]) ContextMenu.selected[this.scope] = null;
});

ContextMenu.prototype.after('hide', function() {
  ContextMenu.selected[this.scope] = null
});

ContextMenu.prototype.after('show', function() {
  if(ContextMenu.selected[this.scope]) ContextMenu.selected[this.scope].hide();
  ContextMenu.selected[this.scope] = this;
});

ContextMenu.hideAll = function(){
  var selected = ContextMenu.selected;
  for(var menu in selected) if(selected[menu]) selected[menu].hide();
};

/*--------------------------------------------------------------------------*/
// SweetTitle
// Copyright (c) 2007 Tobie Langel (http://tobielangel.com) & Gnolia Systems LP.
// Loosely based on the work of Dustin Diaz (http://www.dustindiaz.com)

var SweetTitle = Class.create();
SweetTitle.prototype = {
  initialize: function(element){
    this.element = $(element);

    this.options = Object.extend({
      tooltipId: 'tooltip'
    }, arguments[1] || {});

    this.text = '<p>' + this.element.title + '</p>';
    this.element.title = '';
    this.tooltip = $(this.options.tooltipId);
    if(!this.tooltip) this.tooltip = this.createTooltip();
    this.onMouseOverHandler = this.onMouseOver.bind(this);
    this.onMouseOutHandler = this.onMouseOut.bind(this);
    Event.observe(this.element, 'mouseover', this.onMouseOverHandler);
    Event.observe(this.element, 'mouseout', this.onMouseOutHandler);
  },

  createTooltip: function() {
    var tooltip = new Element('div', {
      style: 'display: none; top: 0; left: 0; position: absolute; z-index: 99999',
      id:    this.options.tooltipId
    });
    document.body.appendChild(tooltip);
    return tooltip;
  },

  onMouseOver: function(event) {
    var style = this.getPosition(Event.pointerX(event), Event.pointerY(event));
    this.tooltip.setStyle(style).update(this.text).show();
  },

  onMouseOut: function(event) {
    this.tooltip.update().hide().setStyle({left: '0px', top: '0px'});
  },

  getPosition: function(x, y) {
    var dimensions = this.tooltip.getDimensions();
    x = x + 10;
    y = y + 15;
    if(parseInt(document.documentElement.clientWidth + document.documentElement.scrollLeft) < (dimensions.width + x))
      x = x - dimensions.width - 10;
    if ( parseInt(document.documentElement.clientHeight+document.documentElement.scrollTop) < (dimensions.height + y))
      y = y - dimensions.height - 10;
    return {left: x + 'px', top: y + 'px'};
  }
};

/*--------------------------------------------------------------------------*/

var DelayedHoverer = Class.create();
DelayedHoverer.active = {};

DelayedHoverer.deactivate = function(scope) {
  if (!scope) return;
  scope = DelayedHoverer.active[scope];
  if (scope) scope.deactivate();
};

Object.extend(DelayedHoverer.prototype, Object.extend(Blueprint.Basic, {
  initialize: function(element) {
    this.element = $(element);

    this.options = Object.extend({
      enterDelay: 0.5,
      leaveDelay: 0.5,
      scope: 'global'
    }, arguments[1] || {});

    this.region = $(this.options.region);

    if(Prototype.Browser.IE) {
      this.handlers = $H({
        'element:mouseenter': this.enterElement.bindAsEventListener(this),
        'element:mouseleave': this.leaveElement.bindAsEventListener(this),
        'region:mouseenter': this.enterRegion.bindAsEventListener(this),
        'region:mouseleave': this.leaveRegion.bindAsEventListener(this)
      });
    } else {
      this.handlers = $H({
        'element:mouseover': this._temp.bindAsEventListener(this, 'enterElement'),
        'element:mouseout': this._temp.bindAsEventListener(this, 'leaveElement'),
        'region:mouseover':  this._temp.bindAsEventListener(this, 'enterRegion'),
        'region:mouseout':  this._temp.bindAsEventListener(this, 'leaveRegion')
      });
    }

    this.event('initialize', this);
    this.addObservers();
  },

  active: false,

  enterElement: function(event) {
    if (this.active) return;
    this.stop();
    DelayedHoverer.deactivate(this.options.scope);
    this.timer = this.activate.bind(this).delay(this.options.enterDelay);
    this.event('enterElement', this);
  },

  leaveElement: function(event) {
    if (this.active) return;
    this.stop();
    this.event('leaveElement', this);
  },

  enterRegion: function(event) {
    if (!this.active) return;
    this.stop();
    this.event('enterRegion', this);
  },

  leaveRegion: function(event) {
    this.stop();
    this.timer = this.deactivate.bind(this).delay(this.options.leaveDelay);
    this.event('leaveRegion', this);
  },

  _temp: function(event, callback) {
    var rel = event.relatedTarget, cur = event.currentTarget;
    if (rel && rel.nodeType == 3) rel = rel.parentNode;
    if (rel && rel != cur && !rel.descendantOf(cur)) this[callback](event);
  },

  activate: function() {
    if (this.active) return;
    var scope = this.options.scope;
    if (scope) DelayedHoverer.active[scope] = this;
    this.event('activate', this);
    this.active = true;
  },

  deactivate: function() {
    if (!this.active) return;
    var scope = this.options.scope;
    if (scope) DelayedHoverer.active[scope] = null;
    this.event('deactivate', this);
    this.active = false;
  },

  stop: function() {
    if (!this.timer) return;
    clearInterval(this.timer);
    this.timer = null;
    this.event('stop', this);
  }
}));

/*--------------------------------------------------------------------------*/