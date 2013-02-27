module AdminData
  module BuildKlasses
    def build_klasses
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
  end
end