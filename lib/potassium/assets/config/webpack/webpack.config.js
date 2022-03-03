const { webpackConfig, merge } = require('shakapacker');
const { vueConfig, cssConfig, jQueryConfig, typescriptConfig } = require('./rules');

module.exports = merge(typescriptConfig, cssConfig, jQueryConfig, webpackConfig);
