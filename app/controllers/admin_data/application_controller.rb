module AdminData

  class ApplicationController < ::ApplicationController

    include ::AdminData::BuildKlasses

    before_filter :ensure_is_allowed_to_view

    helper_method :is_allowed_to_update?

    layout 'admin_data'

    before_filter :build_klasses,  
                  :check_page_parameter, 
                  :prepare_drop_down_klasses

    attr_reader :klass

    protected

    self.config.asset_path = lambda {|asset| "/admin_data/public#{asset}"}


    private

    def prepare_drop_down_klasses
      k = params[:klass] || ''
      @drop_down_url = "http://#{request.host_with_port}/admin_data/quick_search/#{CGI.escape(k)}"
    end

    def ensure_is_allowed_to_view
      render :text => 'not authorized' unless is_allowed_to_view?
    end

    def ensure_is_allowed_to_update
      render :text => 'not authorized' unless is_allowed_to_update?
    end

    def get_class_from_params
      begin
        @klass = Util.camelize_constantize(params[:klass])
      rescue TypeError => e # in case no params[:klass] is supplied
        render :text => 'wrong params[:klass] was supplied' and return
      rescue NameError # in case wrong params[:klass] is supplied
        render :text => 'wrong params[:klass] was supplied' and return
      end
    end

    def check_page_parameter
      # Got hoptoad error because of url like
      # http://localhost:3000/admin_data/User/advance_search?page=http://201.134.249.164/intranet/on.txt?
      if params[:page].blank? || (params[:page] =~ /\A\d+\z/)
        # proceed
      else
        render :text => 'Invalid params[:page]', :status => :unprocessable_entity
      end
    end

    def per_page
      AdminData.config.number_of_records_per_page
    end

    def is_allowed_to_view?
      AdminData.config.is_allowed_to_view.call(self)
    end

    def is_allowed_to_update?
      AdminData.config.is_allowed_to_update.call(self)
    end
  end
end
