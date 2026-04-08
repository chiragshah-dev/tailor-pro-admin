class Admin::QuestionsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_question, only: %i[show edit update destroy]

  def index
    params.permit(:search, :page, :sort, :direction)

    @questions = Question.all

    if params[:search].present?
      q = "%#{params[:search].strip.downcase}%"
      @questions = @questions.where(
        "LOWER(question) LIKE :q OR LOWER(answer) LIKE :q", q: q
      )
    end

    sortable_columns = {
      "question"   => "question",
      "active"     => "active",
      "created_at" => "created_at"
    }

    sort_column    = sortable_columns[params[:sort]] || "created_at"
    sort_direction = params[:direction] == "asc" ? "asc" : "desc"

    @questions = @questions
      .order("#{sort_column} #{sort_direction}")
      .page(params[:page])
      .per(10)
  end

  def show; end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to admin_questions_path, notice: "Question created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      redirect_to admin_questions_path(page: params[:page]), notice: "Question updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    redirect_to admin_questions_path(page: params[:page]), notice: "Question deleted."
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:question, :answer, :active)
  end
end
