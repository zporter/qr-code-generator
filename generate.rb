#!/usr/bin/env ruby

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
require 'rqrcode_png'

class QRCodeGenerator
  class << self
    attr_reader :url

    def run!
      get_url
      save_code
      display_code
    end


    private

    def get_url
      puts 'Enter URL to generate:'
      print '> '

      @url = URI(gets.chomp).to_s
    end

    def save_code
      qr_png.resize(120, 120).save(output_file_path)
    end

    def display_code
      `open #{output_file_path}`
      puts "Save QR Code to #{output_file_path}"
    end

    def qr_png
      qr_code.to_img
    end

    def qr_code
      # size: refers to version of QR and the number of bytes that the QR code
      # can handle.  Use 4 for best results -- 10 works, but it takes a while
      # a scanner to read the code.
      RQRCode::QRCode.new(url, size: 10, level: :h)
    end

    def output_file_path
      @output_file_path ||= File.join('images', 'qr_code.png')
    end
  end
end

QRCodeGenerator.run!
