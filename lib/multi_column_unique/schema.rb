module MultiColumnUnique
  # Provides helper methods that can be used in migrations.
  module Schema
    UNIQUE_TOKEN_NAME = 'unique_token'.freeze
    def self.included(_base)
      ActiveRecord::ConnectionAdapters::Table.send :include, TableDefinition
      ActiveRecord::ConnectionAdapters::TableDefinition.send :include, TableDefinition
      ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, Statements
      ActiveRecord::Migration::CommandRecorder.send :include, CommandRecorder
    end

    module Statements
      def add_unique_token(table_name)
        add_column(table_name, UNIQUE_TOKEN_NAME, :string)
      end

      def remove_unique_token(table_name)
        remove_column(table_name, UNIQUE_TOKEN_NAME)
      end
    end

    module TableDefinition
      def unique_token
        column(UNIQUE_TOKEN_NAME, :string)
      end
    end

    module CommandRecorder
      def add_unique_token(*args)
        record(:add_unique_token, args)
      end

      private

      def invert_add_unique_token(args)
        [:remove_unique_token, args]
      end
    end
  end
end
