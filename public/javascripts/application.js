if(!Magnolia) var Magnolia = {};

Magnolia.options = {
  contextMenu: {
    onShow: function(menu) {
      var menuW = menu.element.getWidth(),
          togglerW = menu.toggler.getWidth() + 2
          width = menuW <= togglerW ? togglerW : menuW;
          
      menu.toggler.up().setStyle({zIndex: 10001}); // IE zIndex Bug
      
      menu.element.setStyle({width: width + 'px'}, true); // IE Bug
      menu.element.select('a').invoke('setStyle', {width: (width - 18) + 'px'}, true); // FF Bug
      
      if(menu._dropShadowAppended) return;
      
      if(!Prototype.Browser.IE || navigator.userAgent.include('MSIE 7'))
        menu.element.appendChild(new Element('div', {className: 'drop-shadow'}))
      
      menu._dropShadowAppended = true;
    },
    
    onHide: function(menu) {
      menu.toggler.up().setStyle({zIndex: 0});  // IE zIndex Bug
    }
  }
};

Magnolia.Rater = Class.create();

Magnolia.Rater.Attributes = [
  {className: 'clear_rating', title: 'clear the rating'},
  {className: 'rated_1',      title: 'Rate this 1 star out of 5'},
  {className: 'rated_2',      title: 'Rate this 2 stars out of 5'},
  {className: 'rated_3',      title: 'Rate this 3 stars out of 5'},
  {className: 'rated_4',      title: 'Rate this 4 stars out of 5'},
  {className: 'rated_5',      title: 'Rate this 5 stars out of 5'}
];

Object.extend(Object.extend(Magnolia.Rater.prototype, Blueprint.Basic), {
  initialize: function(container, rating) {
    container = $(container);
    this.options = Object.extend({
      onRate: function(event) {
        this.setRating(this.getRating(event));
      }
    }, arguments[2] || {});
    
    this.element = this.RATER.cloneNode(true);
    container.insert(this.element);
    
    this.setRating(rating);
    
    this.handlers = $H({
      'mouseover': this.showSelectedRating.bindAsEventListener(this),
      'mouseout':  this.showCurrentRating.bindAsEventListener(this),
      'click':     this.options.onRate.bindAsEventListener(this)
    });
    this.event('initialize', this);
    this.addObservers();
  },
  
  CLASS_NAMES: Magnolia.Rater.Attributes.pluck('className'),
  
  RATER: (function() {
    var ul = new Element('ul');
    Magnolia.Rater.Attributes.each(function(attr) {
      ul.insert(new Element('li', attr));
    });
    return ul;
  })(),
  
  showSelectedRating: function(event) {
    this.element.className = Event.element(event).className;
  },
    
  showCurrentRating: function() {
    this.element.className = this.CLASS_NAMES[this.rating];
  },
  
  setRating: function(rating) {
    this.rating = rating;
    this.element.className = this.CLASS_NAMES[rating]; 
  },
  
  getRating: function(event) {
    return this.CLASS_NAMES.indexOf(Event.element(event).className) || 0;
  }
});

/*--------------------------------------------------------------------------*/
// StreamPicker
// Copyright (c) 2008 Gnolia Systems LP.
// Author: Jesse Clark
// Observes Stream Picker elements and creates an Ajax request for the ActivityStreamsController#pick_activity url which 
// toggles the picked state for the user and activity provided. Then, updates the picked link image tag and updates the
// picks count in the view picks link in the page header.
Magnolia.StreamPicker = Class.create();

Object.extend(Object.extend(Magnolia.StreamPicker.prototype, Blueprint.Basic), {
  initialize: function(element, values) {
    this.element = $(element);
    this.picksLink = $('picks_link');
    this.pickedImage = new Image();
    this.pickedImage.src = '/images/icons/picked.png';
    this.unpickedImage = new Image();
    this.unpickedImage.src = '/images/icons/unpicked.png';
    if( this.element.hasClassName('picked') ) {
      this.picked = true;
    } else {
      this.picked = false;
    }
    screenNameRegexp = new RegExp('/people/(.*)/activity/')
    this.screenName = screenNameRegexp.exec(this.element.readAttribute('href'))[1];
    this.activityId = this.element.readAttribute('href').split('/').last();
    this.handlers = $H({
      'click':     this.togglePicked.bindAsEventListener(this)
    });
    
    this.addObservers();
  },
  
  url: new Template('/people/#{screenName}/activity/pick/#{activityId}'),
  
  togglePicked: function(event) {
    
    this.togglePickedImage();
    new Ajax.Request(this.url.evaluate({screenName: this.screenName, activityId: this.activityId}), {
      onComplete: this.onPickToggled.bind(this)
    });
    Event.stop(event);
  },
  
  onPickToggled: function(event) {
    this.updatePicksLink();
  },
  
  togglePickedImage: function() {
    if( this.picked ) {
      this.element.update(this.unpickedImage);
      this.element.removeClassName('picked');
      this.picked = false;
    } else {
      this.element.update(this.pickedImage);
      this.element.addClassName('picked');
      this.picked = true;
    }
  },
  
  updatePicksLink: function() {
    startColor = this.picksLink.getStyle('color')
    this.picksLink.morph( {color: '#9EB847'}, { delay: 0, duration: 0.5, afterFinish: this.updateCount.bind(this) } );
    this.picksLink.morph( {color: startColor}, { delay: 0, duration: 0.5, queue: 'end' } );
  },
  
  updateCount: function() {
    if( this.picked ) {
      this.picksLink.update( this.picksLink.innerHTML.sub( /\d+/, this.additionMatcher ) );
    } else {
      this.picksLink.update( this.picksLink.innerHTML.sub( /\d+/, this.subtractionMatcher ) );
    }
  },
  
  additionMatcher: function(match) { return parseInt(match[0]) + 1; },
  subtractionMatcher: function(match) { return parseInt(match[0]) - 1; }
  
});

Magnolia.ValueToggler = Class.create();

Object.extend(Object.extend(Magnolia.ValueToggler.prototype, Blueprint.Basic), {
  initialize: function(element, values) {
    this.element = $(element);
    this.values = values;
    this.value = this.toIndex(this.element.innerHTML.strip());
    this.element.addClassName('active');

    this.options = Object.extend({
      valueType: 'number',
      onToggle: function() {
        this.setValue(!this.value);
      }
    }, arguments[2] || {});
    
    this.handlers = $H({
      'mouseover': Element.addClassName.curry(this.element, 'hovered'),
      'mouseout':  Element.removeClassName.curry(this.element, 'hovered'),
      'click':     this.options.onToggle.bindAsEventListener(this)
    });
    
    this.addObservers();
  },

  getValue: function(type) {
    type = (type || this.options.valueType).toLowerCase();
    var value = this.toIndex(!this.value);
    switch(type) {
      case 'number' : return value;
      case 'boolean': return !!value;
      default       : return this.values[value];
    }
  },
  
  setValue: function(value) {
    this.value = this.toIndex(value);
    this.element.update(this.values[this.value]).removeClassName('hovered');
  },
  
  toIndex: function(value) {
    var type = typeof value;
    switch(type) {
      case 'number' : return value;
      case 'boolean': return value ? 1 : 0;
      default       : return this.values.indexOf(value);
    }
  }
});

/*--------------------------------------------------------------------------*/
// IdValueToggler
// Copyright (c) 2007 Gnolia Systems LP.
// Author: Jesse Clark
// Creates a Toggler that will show an element with the id equal to the value 
// of the toggler element and will hide any previously selected element.

var IdValueToggler = Class.create();
Object.extend(Object.extend(IdValueToggler.prototype, Toggler.prototype), {
  
  _parent: Toggler.prototype,
  
  initialize: function(toggler) {
    
    this._parent.initialize.call(this, toggler, null);
    this.handlers = $H({
      'toggler:change': this.toggle.bindAsEventListener(this)
    });
    
    this.toggle(); // set the initial visibility state
    
  },
  
  toggle: function(event) {

    if( e = $( this.toggler.value ) ) { // only toggle if an element exists for the value of the toggler

      // first turn off any existing visible element
      if( this.element != null ) {
        if( this.element.visible() ) { 
          this.hide();
        }
      }
      
      // then update the element to the new value and show it
      this.element = e;
      this.show();
      if( event ) Event.stop(event);
      this.event('toggle', this);
      
    }
  },

  // had to override show() and hide() to not use the byClassName versions of element.show and element.hide
  show: function() {
    if(this.options.className) this.toggler.addClassName(this.options.className)
    this.element.show();
    this.event('show', this);
  },  

  hide: function() {
    if(this.options.className) this.toggler.removeClassName(this.options.className)
    this.element.hide();    
    this.event('hide', this);
  }
});

/*--------------------------------------------------------------------------*/
// ValueToggler
// Copyright (c) 2007 Gnolia Systems LP.
// Author: Jesse Clark
// Creates a Toggler that will show/hide a given element based on whether or not the value 
// attribute of another element is in a provided set of values.

var ValueToggler = Class.create();
Object.extend(Object.extend(ValueToggler.prototype, Toggler.prototype), {
  _parent: Toggler.prototype,
  
  initialize: function(toggler, element) {
    this._parent.initialize.call(this, toggler, element, arguments[2]);
    this.handlers = $H({
      'toggler:blur': this.toggle.bindAsEventListener(this)
    });
    this.toggle(); // set the initial visibility state
  },
  
  toggle: function(event) {
    if( this.options.toggleValues &&  this.options.toggleValues.include( this.toggler.value ) ) {
      this.element.visible() ? this.hide() : this.show();
      if( event ) Event.stop(event);
      this.event('toggle', this);
    }
  },

  // had to override show() and hide() to not use the byClassName versions of element.show and element.hide
  show: function() {
    if(this.options.className) this.toggler.addClassName(this.options.className)
    this.element.show();
    this.event('show', this);
  },  

  hide: function() {
    if(this.options.className) this.toggler.removeClassName(this.options.className)
    this.element.hide();
    this.event('hide', this);
  }
});

/*--------------------------------------------------------------------------*/
// LocalSelectUpdater
// Copyright (c) 2007 Gnolia Systems LP.
// Author: Jesse Clark
// Toggles display of the option groups of a select box based on the selected value of a given watch element.
// The update method fires on the blur event of the watch element. So, this should work for any watch element that
// has a value and supports onblur. I named the class "Local" to indicate that all the option groups for the select 
// need to exist in the page already as no remote call is made to get the new options.

var LocalSelectUpdater = Class.create();
Object.extend(Object.extend(LocalSelectUpdater.prototype, Blueprint.Basic), {
  initialize: function(watchElement, selectBox) {
    this.options = arguments[2] || {};
    this.watchElement = $(watchElement);
    this.selectBox = $(selectBox);

    this.handlers = $H({
      'watchElement:blur': this.updateChildSelect.bindAsEventListener(this)
    });
    this.addObservers();
    this.updateChildSelect(); // set the initial visibility state
    this.event('initialize', this);
  },

  updateChildSelect: function(event) {
    var optionGroups = $$( "#" + this.selectBox.id + " optgroup" )
    // iterate over optionGroups and toggle display based on watchElement.value == optionGroup.optgroup_#{id}
    optionGroups.each( function(group) {// for some reason passing the regex to the iterator was causing it's value to be 0..?
      group.id.match( new RegExp( "(" + this.watchElement.value + ")" ) ) ? group.show() : group.hide();
    }.bind(this) );
    if(event) { Event.stop(event) };
  }
});

/*--------------------------------------------------------------------------*/
// FieldValueReplicator
// Copyright (c) 2007 Gnolia Systems LP.
// Author: Jesse Clark
// Handles the onchange event of given text field watchElement and updates the contents of the targetElement with
// the current value of the watch element by subbing the value of matchString for the value of subString. 
// If replaceContent is provided and is true, the entire contents of the the targetElement will be replaced by the 
// value of the watchElement with no substitution.
// 

var FieldValueReplicator = Class.create();
Object.extend(Object.extend(FieldValueReplicator.prototype, Blueprint.Basic), {
  initialize: function(watchElement, targetElement, matchString, replaceContent) {
    this.options = {};
    this.watchElement = $(watchElement);
    this.targetElement = $(targetElement);
    this.originalContent = this.targetElement.innerHTML.strip();
    this.contentTemplate = new Template( this.originalContent );
    this.matchString = matchString;
    this.replaceContent = replaceContent;

    this.handlers = $H({
      'watchElement:keyup': this.updateTargetElement.bindAsEventListener(this)
    });
    this.addObservers();
    this.updateTargetElement(); // set the initial visibility state
    this.event('initialize', this);
  },

// Todo change this to automatically sub out user_name or blog_name!
  updateTargetElement: function(event) {
    
    if( this.replaceContent == true ) {
      this.targetElement.update( this.subString );
    } else {
      var templateHash = new Hash();
      templateHash.set( this.matchString, this.watchElement.value );
      var newContent = this.contentTemplate.evaluate( templateHash );
      if( this.watchElement.value != '' )
        this.targetElement.update( newContent );
      else
        this.targetElement.update( this.originalContent );
    }
  }
});

Magnolia.Bookmark = Class.create();

Object.extend(Object.extend(Magnolia.Bookmark.prototype, Blueprint.Basic), {
  initialize: function(element) {
    this.element = $(element);

    this.handlers = $H({
      'contactSender:click': this.sendToContacts.bindAsEventListener(this),
      'groupSender:click':   this.sendToGroups.bindAsEventListener(this)
    });
        
    var detailer = this.element.down('.details'),
        sharer = this.element.down('.share'),
        privacyToggler = this.element.down('.privacy');
    
    this.belongsToUser = !!privacyToggler;
    this.id = this.element.id.split('_').last();
    this.screenName = detailer.getElementByTagName('a').readAttribute('href').split('/').last();
    
    this.detailerMenu = this.initializeContextMenu(detailer.getElementByTagName('a'));    
    this.sharerMenu = this.initializeContextMenu(sharer.getElementByTagName('a'));
    this.contactSender = sharer.down('.send-to-contact');  
    this.groupSender   = sharer.down('.send-to-group');

    if(this.belongsToUser) {
      this.initializePrivacyToggler(privacyToggler);
      this.initializeRater(this.element.down('.rate'));
      this.remover = this.element.down('.delete');
      this.handlers.set('remover:click', this.remove.bindAsEventListener(this));
    } else {
      var thanker = null;
      if( this.element.hasClassName('compact') ) {
        thanker = detailer.down('.give-thanks');
      } else {
        thanker = this.element.down('.thanking');        
      }
      if(thanker) this.initializeThanker(thanker);
    }
    
    this.title = this.element.getElementByTagName('h3');
    this.secondaryContent = this.element.down('.secondary-content');
    
    if (this.secondaryContent && false) this.initializeHoverer(this.title.getElementByTagName('a', 1));
    
    this.addObservers();
  },
  
  url: new Template('/bookmarks/#{screenName}/#{action}'),
  
  initializeRater: function(element) {
    var displayer = element.getElementByTagName('span'),
        container = new Element('div', {className: 'starrater'}),
        value;
    if(!displayer) {
      displayer = new Element('span', {className: 'rating'}).appendText(0);
      element.insert(displayer);
    }
    this.ratingDisplayer = displayer;
    
    value = parseInt(displayer.innerHTML);
    
    element.childElements().each(Element.hide);
    element.insert(container);
    
    this.rater = new Magnolia.Rater(container, value, {
      onRate: this.rate.bind(this)
    });
    this.storeHandler(this.rater);
  },
    
  rate: function(event) {
    var rating = this.rater.getRating(event);
    this.rater.element.setOpacity(.5);
    this.rater.removeObservers();
    new Ajax.Request(this.url.evaluate({screenName: this.screenName, action: 'rate'}), {
      postBody: 'rating=' + rating,
      onComplete: this.onRated.bind(this, rating)
    });
  },
  
  onRated: function(rating) {
    this.rater.setRating(rating);
    this.ratingDisplayer.update(rating);
    this.rater.element.appear({duration: 0.2});
    this.rater.addObservers();
  },
  
  initializePrivacyToggler: function(element) {
    this.privacyToggler = new Magnolia.ValueToggler(element, ['Public', 'Private'], {
      onToggle: this.confirmPrivacyToggling.bind(this)
    });
    this.storeHandler(this.privacyToggler);
  },
  
  confirmPrivacyToggling: function() {
    var value = this.privacyToggler.getValue();
    if (!value) {
      this.keepHovererVisible();
      DialogBox.create( 'Confirm', {
        okayText: 'Ok',
        cancelText: 'Cancel',
        messageTemplate: '<p><strong>Are you sure you wish to make this bookmark public?</strong></p>',
        onCancel: this.closeDialog.bind(this),
        onOkay: this.closeDialog.bind(this, 'togglePrivacy', value)
      });
    } else this.togglePrivacy(value);  
  },

  togglePrivacy: function(value) {
    this.privacyToggler.element.processing({text: 'Saving'});
    new Ajax.Request(this.url.evaluate({screenName: this.screenName, action: 'save/privacy'}), {
      postBody: 'new&value=' + value, //  the new param is there just to handle the transition between the old and new system
      onComplete: this.onPrivacyToggled.bind(this, value)
    });  
  },
    
  onPrivacyToggled: function(value) {
    this.privacyToggler.element.stopProcessing().toggleClassName('private');
    this.privacyToggler.setValue(value);
    this.hideHoverer();
  },
  
  thankingMessage: new Template('<p><strong>Do you want to thank #{username} for this bookmark?</strong></p>'),
  
  getUserName: function() {
    return this.element.down('.author').innerHTML;
  },

  initializeThanker: function(element) {
    if( element.innerHTML.include('Thanked')) return;
    this.thanker = element.update('Give Thanks').addClassName('active');
    this.handlers.set('thanker:click', this.confirmThanking.bindAsEventListener(this));
    this.handlers.set('thanker:mouseover', Element.addClassName.curry(this.thanker, 'hovered'));
    this.handlers.set('thanker:mouseout', Element.removeClassName.curry(this.thanker, 'hovered'));
  },
  
  confirmThanking: function(event) {
    this.keepHovererVisible();
    DialogBox.create('Confirm', {
      okayText: 'Give Thanks',
      cancelText: 'Cancel',
      messageTemplate: this.thankingMessage.evaluate({username: this.getUserName()}),
      onCancel: this.closeDialog.bind(this),
      onOkay: this.closeDialog.bind(this, 'thank')
    });  
    Event.stop(event);
  },

  thank: function() {
    this.thanker.processing({text: 'Thanking'});
    new Ajax.Request(this.url.evaluate({screenName: this.screenName, action: 'thanks'}), {
      onComplete: this.onThanked.bind(this)
    });  
  },
    
  onThanked: function(value) {
    this.thanker.stopProcessing().update('Thanked').removeClassName('active');
    this.hideHoverer();
    this.handlers.each(function(handler) {
      if (handler.key.startsWith('thanker'))
        this.thanker.stopObserving(handler.key.split(':').last(), handler.value);
    }.bind(this));
  },

  thumbnailSrc: new Template('http://scst.srv.girafa.com/srv/i?i=sc010159&r=#{url}&s=#{hash}'), // Remove after 
  thumbnailRegexp: /(?:[^:]*:\/\/)(?:www.)?([^?]+).*$/, // having refactored the RJS for SelectUser DialogBox.
  
  sendToContacts: function(event) {
    // The following needs refactoring (removal) once the RJS are cleaned-up
    // The thumbnails should be requested at the same time as the rest of the code
    // not implemented in JS.
    var outlink = this.element.down('.outlink');
    var url = outlink.readAttribute('href');
    var match = url.match(this.thumbnailRegexp);
    url = ((match && match.length > 1) ? match[1] : url).gsub('#', '').gsub(/\/$/, '');
    var hash = this.contactSender.className.split(' ').first().split('_').last();

    UserSelectDialog.create({
      kind: 'Bookmark', 
      thumbnail: this.thumbnailSrc.evaluate({hash: hash, url: url}), 
      name: outlink.innerHTML, 
      id: this.id, 
      recipient: 'user'
    }, { 
      okayText: 'Send',
      cancelText: 'Cancel',
      messageTemplate: '<h2>Send Bookmark Recommendation</h2>',
      message: 'I think you might be interested in this bookmark.'
    });
    this.sharerMenu.hide();
    Event.stop(event);
  },
  
  sendToGroups: function(event) {
    ActionBox.create('Action', {
      dialogClass: 'action_box',
      cancelText: 'Cancel',
      noneFoundLabel: 'Groups', 
      messageTemplate: '<h2>Save This Bookmark to a Group</h2><div id="action_pane" class="action_box">Loading groups you can add to...</div>',
      collection: 'contribution_allowed_groups',
      action_url: '/groups/__which__/bookmarks/add/' + this.screenName,
      remote: true, 
      _target: '_self', 
      onCancel: ActionBox.close,
      closeAfterRequest: false
    });
    this.sharerMenu.hide();
    Event.stop(event);
  },
  
  remove: function(event) {
    DialogBox.create('Confirm', {
      okayText: 'Delete',
      cancelText: 'Cancel',
      messageTemplate: '<p><strong>Are you sure you wish to delete this bookmark? This cannot be undone.</strong></p>',
      onCancel: DialogBox.close,
      onOkay: function() {
        this.removeObservers();
        this.remover.processing({text: 'Deleting'});
        DialogBox.close();
        new Ajax.Request(this.url.evaluate({screenName: this.screenName, action: 'delete'}), {
          onComplete: this.onRemoved.bind(this)
        });
      }.bind(this)
    });
    Event.stop(event);
  },
  
  onRemoved: function() {
    this.remover.stopProcessing().update('Deleted!');
    this.externalHandlers.invoke('removeObservers');
    this.element.fade({
      delay:       0.2,
      duration:    0.3,
      afterFinish: function(effect) {
        effect.element.remove();
      }      
    });
  },
  
  initializeContextMenu: function(element) {
    return this.storeHandler(
      new ContextMenu(element, element.next(),
        Magnolia.options.contextMenu)
    );
  },
  
  initializeHoverer: function(element) {
    this.secondaryContentHoverer = new DelayedHoverer(element, {
      region: this.element,
      
      onEnterElement: function(hoverer) {
        if (hoverer._initialized) return;
        
        hoverer.element.writeAttribute({title: false})
        hoverer.element.observe('click', function() {
          this.stop();
          this.removeObservers();
          this.deactivate();
        }.bind(hoverer));
        
        var windowCloser = new Element('a', {className: 'window-closer'}).appendText('close');
        this.insert(windowCloser);
        windowCloser.observe('click', hoverer.deactivate.bind(hoverer));
        
        //if(!Prototype.Browser.IE || navigator.userAgent.include('MSIE 7'))
          //this.appendChild(new Element('div', {className: 'drop-shadow'}));
          
        hoverer._initialized = true;
      }.bind(this.secondaryContent),
      
      onActivate: function() {
        this.up().setStyle({height: this.getHeight() + 'px'})
        this.slideDown({duration: 0.15});
        ContextMenu.hideAll();
      }.bind(this.secondaryContent),
      
      onDeactivate: function() {
        this.slideUp({
          duration: 0.15,
          afterFinish: function(fx) { fx.element.up().setStyle({height: '0'}) }
        });
      }.bind(this.secondaryContent)
    });
    
    this.storeHandler(this.secondaryContentHoverer);
  },
  
  keepHovererVisible: function() {
    var hoverer = this.secondaryContentHoverer;
    if (!hoverer) return;
    hoverer.stop();
    hoverer.removeObservers();
  },

  hideHoverer: function() {
    var hoverer = this.secondaryContentHoverer;
    if (hoverer) hoverer.deactivate.bind(hoverer).delay(0.5);
  },
  
  closeDialog: function() {
    var args = $A(arguments), action = args.shift();
    if (action) this[action].apply(this, args);
    DialogBox.close();
    var hoverer = this.secondaryContentHoverer;
    if (!hoverer) return;
    hoverer.addObservers();
    if (!action) hoverer.deactivate();
  },
  
  storeHandler: function(handler) {
    if (!this.externalHandlers) this.externalHandlers = [];
    this.externalHandlers.push(handler);
    return handler;
  }
});


function checkScreenName(name, element, token){
  $(element).update("<img src=\"/images/chrome/spinner_on_b.gif\" class=\"status_icon\" /> Checking...");
  new Ajax.Updater(element, '/registration/check_screen_name?name=' + encodeURIComponent(name) + '&authenticity_token=' + token, {evalScripts:true});
}

function checkEmail(email, element, token){
  $(element).update("<img src=\"/images/chrome/spinner_on_b.gif\" class=\"status_icon\" /> Checking...");
  new Ajax.Updater(element, '/registration/check_email?email=' + encodeURIComponent(email) + '&authenticity_token=' + token, {evalScripts:true});
}

function checkPasswords(element) {
  element = $(element);
  var password = $('user_password'), confirm_password = $('user_confirm_password');
  if( !(password.present() && confirm_password.present()) )
    element.update("<img src=\"/images/icons/yellow_reject.gif\" class=\"status_icon\"/> Passwords must not be blank.");
  else if(password.value == confirm_password.value) 
    element.update("<img src=\"/images/icons/green_accept.gif\" class=\"status_icon\"/> Password verified.");
  else element.update("<img src=\"/images/icons/yellow_reject.gif\" class=\"status_icon\"/> Passwords do not match.");
}
