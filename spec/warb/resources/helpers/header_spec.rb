# frozen_string_literal: true

RSpec.describe Warb::Resources::Helpers::Header do
  class DummyClass
    include Warb::Resources::Helpers::Header

    attr_accessor :header
  end

  subject { DummyClass.new }

  describe '#add_text_header' do
    it do
      expect do
        subject.add_text_header(content: 'John', parameter_name: 'part_of_the_day')
      end.to change(subject, :header).from(NilClass).to(Warb::Resources::Text)
    end
  end

  describe '#add_image_header' do
    context 'with id, using block' do
      it do
        expect do
          subject.add_image_header(media_id: 'media_id') do |image|
            expect(image).to be_a Warb::Resources::Image
            expect(image).to eq subject.header
          end
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Image)
      end
    end

    context 'with link, without using block' do
      it do
        expect do
          image = subject.add_image_header(link: 'media_link')

          expect(image).to be_a Warb::Resources::Image
          expect(image).to eq subject.header
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Image)
      end
    end
  end

  describe '#add_document_header' do
    context 'with id, using block' do
      it do
        expect do
          subject.add_document_header(media_id: 'media_id') do |document|
            expect(document).to be_a Warb::Resources::Document
            expect(document).to eq subject.header
          end
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Document)
      end
    end

    context 'with link, without using block' do
      it do
        expect do
          document = subject.add_document_header(link: 'media_link')

          expect(document).to be_a Warb::Resources::Document
          expect(document).to eq subject.header
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Document)
      end
    end
  end

  describe '#add_video_header' do
    context 'with id, using block' do
      it do
        expect do
          subject.add_video_header(media_id: 'media_id') do |video|
            expect(video).to be_a Warb::Resources::Video
            expect(video).to eq subject.header
          end
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Video)
      end
    end

    context 'with link, without using block' do
      it do
        expect do
          video = subject.add_video_header(link: 'media_link')

          expect(video).to be_a Warb::Resources::Video
          expect(video).to eq subject.header
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Video)
      end
    end
  end

  describe '#add_location_header' do
    context 'with id, using block' do
      it do
        expect do
          subject.add_location_header do |location|
            expect(location).to be_a Warb::Resources::Location
            expect(location).to eq subject.header
          end
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Location)
      end
    end

    context 'with link, without using block' do
      it do
        expect do
          location = subject.add_location_header

          expect(location).to be_a Warb::Resources::Location
          expect(location).to eq subject.header
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Location)
      end
    end
  end
end
