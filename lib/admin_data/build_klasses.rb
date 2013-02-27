module AdminData
  module BuildKlasses
    def build_klasses
      @resource_authorized = true
      @klasses ||= _build_all_klasses
    end

    def _build_all_klasses
      if defined? $admin_data_all_klasses
        return $admin_data_all_klasses
      else
        model_dir = File.join(Rails.root, 'app', 'models')
        model_names = Dir.chdir(model_dir) { Dir["*.rb"] }
        klasses = get_klass_names(model_names)
        $admin_data_all_klasses = remove_klasses_without_table(klasses).sort_by {|r| r.name.underscore}
      end
    end

    def get_klass_names(model_names)
      model_names.inject([]) do |output, model_name|
        klass_name = model_name.sub(/\.rb$/,'').camelize
        begin
          output << Util.constantize_klass(klass_name)
        rescue Exception => e
          Rails.logger.debug e.message
        end
        output
      end
    end

    def remove_klasses_without_table(klasses)
      klasses.select { |k| k.ancestors.include?(ActiveRecord::Base) && k.connection.table_exists?(k.table_name) }
    end
  end
end
