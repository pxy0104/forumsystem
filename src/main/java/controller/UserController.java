package controller;

import domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;
import service.UserService;

import javax.annotation.Resource;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
public class UserController {
    @Resource
    private UserService userService;
    @Autowired(required = false)
    private HttpServletRequest request;
   @Autowired
    private HttpSession session;

    /**
     * 用户登录控制
     * 增加登录后更新最近登录时间的逻辑
     *
     * @return
     * @Param user 用户对象（需要用户名和密码）
     */
    @RequestMapping("userLogin.do")
    public ModelAndView userLogin(User user) {
        ModelAndView mv = new ModelAndView();
        String resultStr = null;
        User tmpUser = userService.getUserByUserName(user.getUser_name());
        if (tmpUser == null) { // 先检查用户是否存在
            resultStr = new String("登录失败：用户不存在！");
            mv.setViewName("login.jsp");
        } else { // 用户存在时继续判断密码
            Boolean pwdCheck = user.getUser_password().equals(tmpUser.getUser_password());
            if (pwdCheck) { // 密码正确
                /**
                 * 更新最近登录时间
                 */
                Date tmpDate = new Date(); // 获取当前时间
                tmpUser.setUser_lastLoginTime(tmpDate); // 将登录时间放入对象
                // 执行更新
                userService.modifyUserLastLoginTime(tmpUser);

                // 判断是否能正常登录
                if (tmpUser.getUser_status() != 1) { // 非禁用状态
                    // 登录成功，将用户对象添加到session
                    HttpSession session = request.getSession();
                    session.setAttribute("USER", tmpUser);

                    // 处理是否从查看贴子页面登录的
                    String tipIdStr = null;
                    if (request.getParameter("tipId") != null) {
                        // 记录传过来的贴子id
                        tipIdStr = request.getParameter("tipId");
                    }
                    if (tipIdStr == null || tipIdStr.equals("null")) {
                        mv.setViewName("redirect:toMainPage.do");
                    } else {
                        // 如果用户是在贴子详情中登录的，返回对应的贴子
                        mv.setViewName("redirect:showTip.do?tipId=" + tipIdStr);
                    }
                } else { // user_status == 1 表示被禁用，不能登录
                    resultStr = new String("登录失败：用户已被禁用！请联系管理员（2290418832@qq.com）。");
                    mv.setViewName("login.jsp");
                }
            } else { // 密码不正确
                resultStr = new String("登录失败！密码不正确！");
                mv.setViewName("login.jsp");
            }
        }
        request.setAttribute("myInfo", resultStr);
        return mv;
    }

    /**
     * 用户登出控制
     *
     * @param session
     * @return
     */
    @RequestMapping("userSignOut.do")
    public ModelAndView userSignOut(HttpSession session) {
        ModelAndView mv = new ModelAndView();
        // 移除session中的用户对象
        session.removeAttribute("USER");
        mv.setViewName("redirect:/");
        return mv;
    }

    /**
     * 用户信息页面
     */
    @RequestMapping("getUserInfo.do")
    public ModelAndView getUserInfo(int userId) {
        ModelAndView mv = new ModelAndView();
        User user = userService.getUserById(userId);
        if (user != null) {
            request.setAttribute("userObject", user);
            mv.setViewName("userInfo.jsp");
        } else {
            request.setAttribute("myInfo", "查询用户信息失败！");
            mv.setViewName("main.jsp");
        }
        return mv;
    }

    /**
     * 修改用户信息控制
     *
     * @param user
     * @return
     */
    @RequestMapping("updateUserInfo.do")
    public ModelAndView updateUserInfo(User user) {
        ModelAndView mv = new ModelAndView();
        // 获取原session
        User oldUserInfo = (User) session.getAttribute("USER");
        if (user != null) {
            if (userService.updateUserInfo(user) > 0) {
                User newUserInfo = userService.getUserById(user.getUser_id());
                if (!oldUserInfo.getUser_password().equals(newUserInfo.getUser_password())) {
                    // 如果新旧密码不同，退出登录
                    request.setAttribute("myInfo", "修改用户信息成功。由于您修改了密码，请重新登录！");
                    session.removeAttribute("USER");
                    mv.setViewName("redirect:toMainPage.do");
                } else {
                    // 修改信息后更新session和request
                    request.setAttribute("myInfo", "修改用户信息成功！");
                    // session.removeAttribute("USER");
                    session.setAttribute("USER", newUserInfo);
                    request.setAttribute("userObject", newUserInfo);
                    mv.setViewName("userInfo.jsp");
                }
            } else {
                request.setAttribute("myInfo", "修改用户信息失败！");
                mv.setViewName("userInfo.jsp");
            }
        }
        return mv;
    }

    /**
     * 用户注册控制
     *
     * @param user
     * @return
     */
    @RequestMapping("userSignUp.do")
    public ModelAndView userSignUp(User user) {
        ModelAndView mv = new ModelAndView();
        if (user != null) {
            String resultStr = userService.addUser(user);
            request.setAttribute("myInfo", resultStr);
            mv.setViewName("signUp.jsp");
        }
        return mv;
    }

    /**
     * 禁用用户控制
     *
     * @param userId
     * @return
     */
    @RequestMapping("disableUser.do")
    public ModelAndView disableUser(int userId) {
        ModelAndView mv = new ModelAndView();
        String resultStr = userService.modifyUserStatus(userId, 1);
        request.setAttribute("myInfo", resultStr);
        request.setAttribute("users", this.getUpdateUserData());
        mv.setViewName("userManage.jsp");
        return mv;
    }

    /**
     * 启用用户控制
     *
     * @param userId
     * @return
     */
    @RequestMapping("enableUser.do")
    public ModelAndView enableUser(int userId) {
        ModelAndView mv = new ModelAndView();
        String resultStr = userService.modifyUserStatus(userId, 0);
        request.setAttribute("myInfo", resultStr);
        request.setAttribute("users", this.getUpdateUserData());
        mv.setViewName("userManage.jsp");
        return mv;
    }

    /**
     * 锁定用户控制
     *
     * @param userId
     * @return
     */
    @RequestMapping("lockUser.do")
    public ModelAndView lockUser(int userId) {
        ModelAndView mv = new ModelAndView();
        String resultStr = userService.modifyUserStatus(userId, 2);
        request.setAttribute("myInfo", resultStr);
        request.setAttribute("users", this.getUpdateUserData());
        mv.setViewName("userManage.jsp");
        return mv;
    }

    /**
     * 获取更新后的用户数据
     *
     * @return List<User>
     */
    private List<User> getUpdateUserData() {
        List<User> userList = userService.getAllUser();
        return userList;
    }

    /**
     * 跳转到修改用户信息页面
     *
     * @return
     */
    @RequestMapping("toUpdateUserInfoPage.do")
    public ModelAndView toUpdateUserInfoPage(int userId) {
        ModelAndView mv = new ModelAndView();
        User user = userService.getUserById(userId);
        if (user != null) {
            request.setAttribute("userObject", user);
            mv.setViewName("update_userInfo.jsp");
        } else {
            request.setAttribute("myInfo", "修改前获取用户信息失败！");
            mv.setViewName("getUserInfo.do?userId=" + userId);
        }
        return mv;
    }

    /**
     * 模糊查询用户 ajax
     */
    @ResponseBody
    @RequestMapping("searchUserFuzzyByKeywordForAjax.do")
    public Object searchUserFuzzyByKeyword(HttpServletResponse response) {
        response.setContentType("application/json; charset=UTF-8");
        String keyword = request.getParameter("userKeyword");
        List<User> userList = userService.searchUserFuzzy(keyword);
        return userList;
    }

    /**
     * 【用户管理界面】模糊查询用户
     */
    @RequestMapping("searchUsersFuzzy.do")
    public ModelAndView searchUsersFuzzy() {
        ModelAndView mv = new ModelAndView();
        List<User> userList = null;
        // 处理参数
        String userKeyword = request.getParameter("userKeyword"); // 获取输入的关键词
        // 判断关键词是否为空
        if (userKeyword.equals("") || userKeyword.isEmpty()) {
            // 为空时返回所有用户
            userList = userService.getAllUser();
        } else {
            // 不为空时模糊查询
            userList = userService.searchUserFuzzy(userKeyword); // 调用服务层 执行查询
        }
        request.setAttribute("users", userList);
        mv.setViewName("userManage.jsp");
        return mv;
    }

    /**
     * 跳转到修改昵称页面
     *
     * @return
     */
    @RequestMapping("toModifyNickNamePage.do")
    public ModelAndView toModifyNickNamePage(int userId) {
        ModelAndView mv = new ModelAndView();
        User user = userService.getUserById(userId);
        if (user != null) {
            request.setAttribute("userObject", user);
            // 跳转页面
            mv.setViewName("user_modify_nickName.jsp");
        } else {
            request.setAttribute("myInfo", "获取用户信息失败！");
            mv.setViewName("getUserInfo.do?userId=" + userId);
        }
        return mv;
    }

    /**
     * 修改用户昵称
     * 2020-09-25 16:18 新增
     *
     * @param user 用户对象
     * @return
     */
    @RequestMapping("modifyUserNickName.do")
    public ModelAndView modifyUserNickName(User user) {
        ModelAndView mv = new ModelAndView();
        // 传入对象判空
        if (user != null) {
            String tempUserIdStr = user.getUser_id() + "";
            // 基础数据判空
            if (!"".equals(tempUserIdStr) && user.getUser_nick() != null) {
                // 执行更新
                int result = userService.modifyUserNickName(user);
                if (result < 1) { // 失败
                    request.setAttribute("myInfo", "修改用户信息失败！请联系管理员");
                    mv.setViewName("userInfo.jsp");
                } else { // 成功
                    // 获取新user信息
                    User newUserInfo = userService.getUserById(user.getUser_id());
                    // 刷新session
                    session.setAttribute("USER", newUserInfo);
                    // 刷新request
                    request.setAttribute("userObject", newUserInfo);
                    request.setAttribute("myInfo", "修改昵称成功！");
                    // 跳转用户信息页面
                    mv.setViewName("userInfo.jsp");
                }
            }
        }
        return mv;
    }
}
