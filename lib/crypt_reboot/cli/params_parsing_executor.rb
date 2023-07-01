# frozen_string_literal: true

module CryptReboot
  module Cli
    # Interprets parameters, executes everything and returns callable object
    class ParamsParsingExecutor
      def call(raw_params)
        params = parser.call(raw_params)
        handle_action_params!(params) or configure_and_exec(params)
      rescue StandardError => e
        raise if debug?

        sad_exiter_class.new(error_message(e))
      end

      private

      def debug?
        debug_checker.call
      end

      def configure_and_exec(params)
        config_updater.call(**params)
        loader.call
        rebooter
      end

      def handle_action_params!(params)
        return happy_exiter_class.new(help_generator.call) if params[:help]
        return happy_exiter_class.new(version_string) if params[:version]

        params.reject! { |param_name, _| %i[help version].include? param_name }

        false
      end

      def exception_name(exception)
        name = exception.class.name.split('::').last
        name.gsub(/([a-z\d])([A-Z])/, '\1 \2').capitalize
      end

      def error_message(exception)
        "#{exception_name(exception)}: #{exception.message}"
      end

      attr_reader :parser, :config_updater, :loader, :help_generator,
                  :version_string, :debug_checker, :rebooter,
                  :happy_exiter_class, :sad_exiter_class

      # rubocop:disable Metrics/ParameterLists
      def initialize(parser: Params::Parser.new,
                     config_updater: Config.method(:update!),
                     loader: KexecPatchingLoader.new,
                     help_generator: Params::HelpGenerator.new,
                     version_string: "cryptreboot #{VERSION}",
                     debug_checker: LazyConfig.debug,
                     rebooter: Rebooter.new,
                     happy_exiter_class: HappyExiter,
                     sad_exiter_class: SadExiter)
        @parser = parser
        @config_updater = config_updater
        @loader = loader
        @help_generator = help_generator
        @version_string = version_string
        @debug_checker = debug_checker
        @rebooter = rebooter
        @happy_exiter_class = happy_exiter_class
        @sad_exiter_class = sad_exiter_class
      end
      # rubocop:enable Metrics/ParameterLists
    end
  end
end
