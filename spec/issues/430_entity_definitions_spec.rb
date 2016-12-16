require 'spec_helper'

describe 'definition names' do
  before :all do
    module TestDefinition
      module DummyEntities
        module WithVeryLongName
          module AnotherGroupingModule
            class Class1
              class Entity < Grape::Entity
                expose :first_thing
              end
            end

            class Class2
              class Entities < Grape::Entity
                expose :second_thing
              end
            end

            class Class3
              class Entity < Grape::Entity
                expose :third_thing

                def self.entity_name
                  'FooKlass'
                end
              end
            end

            class Class4
              class FourthEntity < Grape::Entity
                expose :fourth_thing
              end
            end

            class Class5
              class FithEntity < Class4::FourthEntity
                expose :fith_thing
              end
            end

            class Class6
              class SixthEntity < Grape::Entity
                expose :sixth_thing

                def self.entity_name
                  'BarKlass'
                end
              end
            end

            class Class7
              class SeventhEntity < Class6::SixthEntity
                expose :seventh_thing
              end
            end
          end
        end
      end

      class NameApi < Grape::API
        add_swagger_documentation models: [
          DummyEntities::WithVeryLongName::AnotherGroupingModule::Class1::Entity,
          DummyEntities::WithVeryLongName::AnotherGroupingModule::Class2::Entities,
          DummyEntities::WithVeryLongName::AnotherGroupingModule::Class3::Entity,
          DummyEntities::WithVeryLongName::AnotherGroupingModule::Class4::FourthEntity,
          DummyEntities::WithVeryLongName::AnotherGroupingModule::Class5::FithEntity,
          DummyEntities::WithVeryLongName::AnotherGroupingModule::Class6::SixthEntity,
          DummyEntities::WithVeryLongName::AnotherGroupingModule::Class7::SeventhEntity
        ]
      end
    end
  end

  let(:app) { TestDefinition::NameApi }

  subject do
    get '/swagger_doc'
    JSON.parse(last_response.body)['definitions']
  end

  specify { expect(subject).to include 'Class1' }
  specify { expect(subject).to include 'Class2' }
  specify { expect(subject).to include 'FooKlass' }
  specify { expect(subject).to include 'FourthEntity' }
  specify { expect(subject).to include 'FithEntity' }
  specify { expect(subject).to include 'BarKlass' }
  specify { expect(subject).to include 'SeventhEntity' }
end
