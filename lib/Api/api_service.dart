import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zumajobs/models/applicant_resp.dart';
import 'package:zumajobs/models/home_resp.dart';
import 'package:zumajobs/models/model_resp.dart';
import 'package:zumajobs/models/register_resp.dart';
import 'package:zumajobs/models/sector_resp.dart';
import 'package:zumajobs/models/user_resp.dart';
import 'package:zumajobs/models/vacancy_resp.dart';
import 'package:zumajobs/models/employer_resp.dart';
part 'api_service.g.dart';

const String BASE_URL = "https://zumajob.herokuapp.com/api/";

@RestApi(baseUrl: BASE_URL)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  static ApiService create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return ApiService(dio);
  }

  @POST("https://zumajob.herokuapp.com/auth/reg")
  @FormUrlEncoded()
  Future<RegisterResp> createUser(
    @Field("username") String username,
    @Field("email") String email,
    @Field("type") String type,
    @Field("country") String country,
    @Field("password1") String password1,
    @Field("password2") String password2,
  );

  @POST("https://zumajob.herokuapp.com/auth/login/")
  @FormUrlEncoded()
  Future<RegisterResp> login(
    @Field("email") String email,
    @Field("password") String password,
  );

  @POST("https://zumajob.herokuapp.com/auth/password/reset/")
  @FormUrlEncoded()
  Future<RegisterResp> reset(
    @Field("email") String email,
  );

  @POST("gethome")
  Future<HomeResp> get_home(@Body() var token);

  @POST("getuser")
  Future<UserResp> get_user(@Body() var token);

  @POST("updateuser")
  Future<ModelResp> update_user(@Body() var data);

  @POST("getsector")
  Future<SectorResp> get_sector(@Body() var token);

  @POST("getvacancy")
  Future<VacancyResp> get_vacancy(@Body() var token);

  @POST("getapps")
  Future<ApplicantResp> get_apps(@Body() var data);

  @POST("findvac")
  Future<VacancyResp> find_vac(@Body() var data);

  @POST("findapp")
  Future<ApplicantResp> find_app(@Body() var data);

  @POST("postview")
  Future<ModelResp> post_view(@Body() var data);

  @POST("postapply")
  Future<ModelResp> post_apply(@Body() var token);

  @POST("postpay")
  Future<ModelResp> post_pay(@Body() var token);

  @POST("getemps")
  Future<EmployerResp> get_emps(@Body() var token);

  @GET("getextra")
  Future<ModelResp> get_extra(@Body() var token);

  @GET("getprivacy")
  Future<ModelResp> get_privacy();
}
