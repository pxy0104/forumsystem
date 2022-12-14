package mapper;

import domain.Reply;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface ReplyMapper {

    /**
     * 添加回复
     * fix:入参缺少修改时间字段
     * @version 1.1
     * @param reply 回复实体对象
     * @return
     */
    @Insert("INSERT INTO reply " +
            "(reply_content, reply_publishTime, reply_modifyTime, user_id, tip_id) " +
            "VALUES " +
            "(#{reply_content}, #{reply_publishTime}, #{reply_modifyTime}, " +
            "${user.user_id}, ${tip.tip_id})")
    int insReply(Reply reply);

    /**
     * 由贴子id查询回复
     * @param tip_id 贴子id
     * @return List<Reply>
     */
    @Select("SELECT * FROM reply WHERE tip_id = #{tip_id}")
    List<Reply> selReplyByTipId(int tip_id);

}
