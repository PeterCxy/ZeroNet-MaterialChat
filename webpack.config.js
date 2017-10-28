const path = require('path');
const webpack = require('webpack');
const isProd = (process.env.NODE_ENV === 'production')

module.exports = {
  entry: './index.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist')
  },
  module: {
    rules: [
      {
        test: /\.coffee$/,
        use: [
          {
            loader: 'coffee-loader',
            options: {
              sourceMap: true,
              transpile: {
                presets: ['env']
              }
            }
          }
        ]
      },
      {
        test: /\.css$/,
        loader: "style-loader!css-loader"
      },
      {
        test: /\.(jpe?g|png|gif|svg|eot|woff|ttf|svg|woff2)$/,
        loader: "base64-inline-loader?name=[name].[ext]"
      },
      {
        test: /\.html$/,
        loader: ['file-loader?name=[name].[ext]', 'html-minify-loader', './autoVer']
      }
    ]
  },
  plugins: [
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      'window.jQuery': 'jquery',
      Popper: ['popper.js', 'default'],
      // In case you imported plugins individually, you must also require them here:
      Util: "exports-loader?Util!bootstrap/js/dist/util",
      Dropdown: "exports-loader?Dropdown!bootstrap/js/dist/dropdown"
    }),
    new webpack.optimize.UglifyJsPlugin({
      sourceMap: true,
      compress: {
        warnings: false,
        screw_ie8: true
      }
    })
  ],
  devtool: 'inline-source-map'
};

if (isProd) {
  module.exports.devtool = ''
}