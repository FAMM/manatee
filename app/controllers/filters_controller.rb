class FiltersController < ApplicationController
  # GET /filters
  # GET /filters.json
  def index
    @filters = Filter.all
  end

  # POST /filters
  # POST /filters.json
  def create
    @filter = Filter.new(filter_params)
		@filter.user = current_user

    respond_to do |format|
      if @filter.save
        format.json { render action: 'show', status: :created, location: @filter }
      else
        format.json { render json: @filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /filters/1
  # PATCH/PUT /filters/1.json
  def update
		@filter_options = parse_raw params[:filter][:raw]
    @filter = Filter.find(@filter_options["id"])

    respond_to do |format|
      if @filter.update(filter_params)
        format.html { redirect_to @filter, notice: 'Filter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /filters/1
  # DELETE /filters/1.json
  def destroy
		@filter = Filter.find( params[:id] )

    @filter.destroy
    respond_to do |format|
      format.html { redirect_to filters_url }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def filter_params
			@filter_options ||= parse_raw( params[:filter][:raw] )
			allowed_params = ["name", "start_date", "end_date", "conditions"]
			filter_params = {}
      @filter_options.each do |key,value|
				if allowed_params.include?(key)
					filter_params[key] = value
				end
			end

			return filter_params
    end

		def parse_raw raw
			begin
				filter_options = JSON.parse( raw.to_s )
			rescue JSON::ParserError
				filter_options = {}
			end

			filter_options["conditions"] ||= []

			# replace the hashes with real filter conditions
			filter_options["conditions"].map!{|c| FilterCondition.new c }

			return filter_options
		end
end
