const { webpackConfig, merge } = require('shakapacker');
const { vueConfig, cssConfig, jQueryConfig } = require('./rules');

module.exports = merge(cssConfig, jQueryConfig, webpackConfig);
