class TestDetailsController < ApplicationController
  # GET /test_details
  # GET /test_details.json
  def index
    @test_details = TestDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @test_details }
    end
  end

  # GET /test_details/1
  # GET /test_details/1.json
  def show
    @test_detail = TestDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @test_detail }
    end
  end

  # GET /test_details/new
  # GET /test_details/new.json
  def new
    @test_detail = TestDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @test_detail }
    end
  end

  # GET /test_details/1/edit
  def edit
    @test_detail = TestDetail.find(params[:id])
  end

  # POST /test_details
  # POST /test_details.json
  def create
    render json: params
    return

    @test_detail = TestDetail.new(params[:test_detail])

    respond_to do |format|
      if @test_detail.save
        format.html { redirect_to @test_detail, notice: 'Test detail was successfully created.' }
        format.json { render json: @test_detail, status: :created, location: @test_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @test_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /test_details/1
  # PUT /test_details/1.json
  def update
    @test_detail = TestDetail.find(params[:id])

    respond_to do |format|
      if @test_detail.update_attributes(params[:test_detail])
        format.html { redirect_to @test_detail, notice: 'Test detail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @test_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_details/1
  # DELETE /test_details/1.json
  def destroy
    @test_detail = TestDetail.find(params[:id])
    @test_detail.destroy

    respond_to do |format|
      format.html { redirect_to test_details_url }
      format.json { head :no_content }
    end
  end

  # Used for checking the test being submitted by user.
  def test_submit
    received_params = params
    received_params.delete(:authenticity_token)
    received_params.delete(:controller)
    received_params.delete(:action)

    #render json: received_params.first[1].size
    #return
    final_score = 0

    @test = TestResult.create(user_id: current_user.id)

    received_params.each do |param|
      @question = Question.find (param[0])
      if ((param[1] === '' || param[1] === 'None') && param[1].size > 1)
        ans='Not Attempted'
        @test.test_details.create(question_id: @question.id, answer: ans, user_id: current_user.id, score: 0)
      else
        ans = param[1]
        final_ans = ''
        score = 0
        if (@question.type == 'FillInTheBlank' || @question.type == 'Rearrange')
          ans = ans.strip
          @option = Option.where(question_id: param[0])
          @option.each do |option|
            (option.key.casecmp(ans) == 0) ? score = @question.options.first.val : score = 0
          end
          final_score += score
          @test.test_details.create(question_id: @question.id, answer: ans, user_id: current_user.id, score: score)
        elsif (@question.type == 'TrueFalse' || @question.type == 'Mcq1')
          score = ans.split('_')[1].to_i
          final_score += score
          @test.test_details.create(question_id: @question.id, answer: ans.split('_')[0], user_id: current_user.id, score: score)
        elsif (@question.type == 'Mcq2' || @question.type == 'Mcq3')
          ans.each do |answer|
            if (answer != 'None')
              @option = Option.find(answer.to_i)
              final_ans += @option.key + '||'
              score += @option.val
            end
          end
          final_score += score
          @test.test_details.create(question_id: @question.id, answer: final_ans, user_id: current_user.id, score: score)
        else
          @test.test_details.create(question_id: @question.id, answer: ans, user_id: current_user.id)
        end
      end
    end

    @test.update_attribute(:obj_score, final_score)
    render action: "submit"
  end

  def submit
  end

  def show_details
    test_id = params[:test_id]
    @test_details = TestDetail.find_all_by_test_result_id(test_id)
    @question_ids = @test_details.map { |td| td.id}]}
    @fill_in_the_blank = Question.where(type: 'FillInTheBlank').where(['id IN (?)', @question_ids])
    render json:@fill_in_the_blank
    return
    @true_false = Question.where(type: 'TrueFalse').where(['id IN (?)', @question_ids])

    @mcq1 = Question.where(type: 'Mcq1').where(['id IN (?)', @test_details.map { |td| td.id}])
    @mcq2 = Question.where(type: 'Mcq2').where(['id IN (?)', @test_details.map { |td| td.id}])
    @mcq3 = Question.where(type: 'Mcq3').where(['id IN (?)', @test_details.map { |td| td.id}])
    @rearrange = Question.where(type: 'Rearrange').where(['id IN (?)', @test_details.map { |td| td.id}])
    #@fill_in_the_blank = Question.where(type: 'FillInTheBlank').where(['id IN (?)', @test_details.map { |td| td.id}])
  end

end
