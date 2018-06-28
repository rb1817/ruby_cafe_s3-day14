class CafesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    # 전체 카페 목록보여주는 페이지
    # -> 로그인 하지않았을 때: 전체 카페 목록
    # => 로그인 했을때: 유저가 카입한 카페 목록
    def index
        if user_signed_in?
            @cafes = current_user.daums
        else
            @cafes = Daum.all
        end
    end
    
    
    # 카페 내용을 보여주는 show 페이지
    def show
        @cafe = Daum.find(params[:id])
        #session[:current_cafe] = @cafe.id
    end
    # 카페를 개설하는 페이지
    def new
        @cafe = Daum.new
    end
    # 카페를 실제로 개설하는 로직
    def create
       @cafe = Daum.new(daum_params)
       @cafe.master_name = current_user.user_name
       if @cafe.save
           Membership.create(daum_id: @cafe.id, user_id: current_user.id)
           redirect_to cafe_path(@cafe), flash: {success:"카페가 개설되었습니다."}
       else
           p @cafe.errors #롤백방지
           redirect_to :back, flash: {danger: "카페 개설에 실패했습니다."}
       end
    end
   
    def join_cafe
        cafe = Daum.find(params[:cafe_id])
        #사용자가 가입하려는 카페
        if cafe.is_member? (current_user)
            #가입실패
            redirect_to :back, flash: {danger: "카페 가입에 실패했습니다."}
        else
            #가입성공
            Membership.create(daum_id: params[:cafe_id], user_id: current_user.id)
            redirect_to :back, flash: {success: "카페 가입에 성공했습니다."}
        end
        
    end
     # 카페 정보를 실제로 수정하는 페이지
    def update
    end
    
    private
    def daum_params
        params.require(:daum).permit(:title, :description)
        # :params => {:daum => {:title
    end
end
