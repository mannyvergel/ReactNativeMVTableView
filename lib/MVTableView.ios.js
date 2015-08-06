//Author and Copyright 2015 to present, Manny Vergel
//MIT License

'use strict';

var React = require('react-native');
var {
  AppRegistry,
} = React;

var requireNativeComponent = require('requireNativeComponent');
var Subscribable = require('Subscribable');
var MVTableViewManager = require('NativeModules').MVTableViewManager;
var StaticRenderer = require('StaticRenderer');


var MVTableView = React.createClass({
  propTypes: {
    getCellTemplate: React.PropTypes.func.isRequired,
    getDataForSectionRow: React.PropTypes.func.isRequired,
    rowHeight: React.PropTypes.number,
    numberOfRowsPerSection: React.PropTypes.arrayOf(React.PropTypes.number).isRequired,
  },


  _onRenderTableRow: function(event) {
    var sectionRow = {section: event.nativeEvent.section, row: event.nativeEvent.row};

    var data = this.props.getDataForSectionRow(sectionRow);
    var reactTag = React.findNodeHandle(this);

    var cellTemplate = this.props.getCellTemplate(sectionRow, data, reactTag);

    if (!cellTemplate) {
      throw new Error("Cell template is required");
    }

    MVTableViewManager.updateRowWithOptions({
      sectionRow: sectionRow,
      reactTag: reactTag,
      data: data,
      cellId: cellTemplate,
    }, function() {
      //callback, might be useful later
    })
  },

  render: function() {
    return (
      <NativeMVTableView onRenderTableRow={this._onRenderTableRow}  {...this.props}  />
    )
  }
})

var NativeMVTableView = requireNativeComponent('MVTableView', MVTableView);


module.exports = MVTableView;

