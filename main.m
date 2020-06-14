//
//  main.m
//  数据结构实训程序
//
//  Created by kendrick Lamar on 2020/3/5.
//  Copyright © 2020 kendrick Lamar. All rights reserved.
//
#import <Foundation/Foundation.h>
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include<regex.h>


//结构体创建
typedef struct
{
    int selected;
    int Ques_num;
    char content[500];
    char answer_A[500];
    char answer_B[500];
    char answer_C[500];
    char answer_D[500];
    char answer;
} Question;

typedef Question ElemType;



//顺序表创建
typedef struct {
    ElemType* List;
    int len;
    int MaxSize;
    
}List;


//typedef struct {
//    ElemType* List;
//    int len;
//    int MaxSize;
//
//}Wrong_List;

//初始化顺序表
void initList(List *L,int ms)
{
    if(ms<10)L->MaxSize = 10;
    else L->MaxSize = ms;
    L->List = (int *)malloc(L->MaxSize* sizeof(ElemType));
    if(!L->List)
    {
        printf("动态储存用完!\n");
        exit(1);
        
    }
    L->len = 0;
}

//添加试题
//试题录入
void add_question(List* L){
    FILE* readf;
    
    if(L->len == L->MaxSize - 1){
        L->List = realloc(L->List,2 * sizeof(ElemType)*L->MaxSize);
        if(!L->List){
            printf("动态储存不足!\n");
            exit(1);
        }
        L->MaxSize = 2*L->MaxSize;
    }
    
    printf("题库中共有%d道题\n",length(L));
    
    readf = fopen("/Users/kendricklamar/Desktop/单项选择题标准化考试系统/Test.txt", "a+");
    if(!readf){
        printf("open error!");
        exit(1);
    }
    printf("\n");
    printf("请输入题目,按照以下格式\n");
    printf("题目内容\n");
    printf("A选项\n");
    printf("B选项\n");
    printf("C选项\n");
    printf("D选项\n");
    printf("答案#\n");
    printf(">>");
    char ch;
    ch = getchar();
    while (ch != '#') {
        fputc(ch, readf);
        ch = getchar();
    }//把题目写入文件
    savefile(L);//保存
    fclose(readf);
    
    char keepgoing;
    printf("继续? Y 或 N\n");
    printf(">>");
    scanf("%s",&keepgoing);
    if(keepgoing == 'Y'){
        add_question(L);
    }
    if(keepgoing == 'N'){
        menu(L);
    }
}

//计算题目个数
int length(List* L)
{
    int total_ques;
    FILE* readf;
    readf = fopen("/Users/kendricklamar/Desktop/单项选择题标准化考试系统/Test.txt","r");
    if(!readf){
        printf("open error!\n");
        exit(1);
    }
    for(total_ques = 0;!feof(readf); total_ques ++){
        fscanf(readf, "%s%s%s%s%s%c", L->List[L->len-1].content, L->List[L->len-1].answer_A, L->List[L->len-1].answer_B, L->List[L->len-1].answer_C, L->List[L->len-1].answer_D, &L->List[L->len-1].answer);
    }
    total_ques = total_ques - 5;
    fclose(readf);
    return total_ques;
}


//答题
int response(List* L){
    printf("题库中共有%d道题\n",length(L));
    FILE* readf;
    char result;
    //result是输入的答案
    int num;
    
    int count = 0;
    printf("\n");
    printf("请选择所需题目个数！\n");
    printf(">>");
    scanf("%d",&num);
    if(num <= length(L)){
        printf("从题库中选取%d道题.\n",num);
    }
    else{
        printf("没有这么多题目！\n");
        response(L);
    }
    
    readf = fopen("/Users/kendricklamar/Desktop/单项选择题标准化考试系统/Test.txt","r+");
    if(!readf){
        printf("open error!\n");
        exit(1);
    }
    
    int total_ques;
    total_ques = length(L);
    
    readfile(L, total_ques);
    
    sleep(2);
    int i = 0;
    while(i < num){
        
        int m;
        srand(time(NULL));
        m = rand()%(total_ques - 1);//随机生成题号
        
        if (L->List[m].selected == 1) {
            continue;
        }else{
            L->List[m].selected = 1;
            printf("\n第%d题：%s\n", i+1, L->List[m].content);
            printf("A:%s\n", L->List[m].answer_A);
            printf("B:%s\n", L->List[m].answer_B);
            printf("C:%s\n", L->List[m].answer_C);
            printf("D:%s\n", L->List[m].answer_D);
            
            printf("请输入答案：");
            scanf("%s",&result);
            printf("\n输入答案为：%c\t", result);
            if(result <= 'z' && result >= 'a'){
                result = result - 32;
            }//把小写字母转换为大写字母
            
            if(result == L->List[m].answer){
                printf("正确！\n");
                count += 1;
            }
            else{
                printf("错误！\t 正确答案为: %c\n", L->List[m].answer);
    
                FILE* secReadf;
                secReadf = fopen("/Users/kendricklamar/Desktop/单项选择题标准化考试系统/record.txt","a+");
                if(secReadf == NULL){
                    printf("File open error!");
                    exit(0);
                }
                
                char another = '\n';
                fwrite(&L->List[m].content, sizeof(L->List[m].content), 1, secReadf);
                fwrite(&another, sizeof(another), 1, secReadf);
                fwrite(&L->List[m].answer_A, sizeof(L->List[m].answer_A), 1, secReadf);
                fwrite(&another, sizeof(another), 1, secReadf);
                fwrite(&L->List[m].answer_B, sizeof(L->List[m].answer_B), 1, secReadf);
                fwrite(&another, sizeof(another), 1, secReadf);
                fwrite(&L->List[m].answer_C, sizeof(L->List[m].answer_C), 1, secReadf);
                fwrite(&another, sizeof(another), 1, secReadf);
                fwrite(&L->List[m].answer_D, sizeof(L->List[m].answer_D), 1, secReadf);
                fwrite(&another, sizeof(another), 1, secReadf);
                fwrite(&L->List[m].answer, sizeof(L->List[m].answer), 1, secReadf);
                fwrite(&another, sizeof(another), 1, secReadf);
                fclose(secReadf);//把错题写入错题本
            }
            i ++;
        }
    }
    printf("--------------\n");
    printf("分数:%d\n",count);
    return 0;

}
void record(){
    char c;
    FILE* readf;
    readf = fopen("/Users/kendricklamar/Desktop/单项选择题标准化考试系统/record.txt","r+");
    printf("\n");
    printf("错题本\n");
    printf("-----------------------------------\n");
    while(fscanf(readf,"%c",&c)!=EOF)
        printf("%c",c);
    fclose(readf);
}//输出错题本中的题目
void showAll(List* L){
    char c;
    
    FILE*fp=NULL;//需要注意
    
    fp=fopen("/Users/kendricklamar/Desktop/单项选择题标准化考试系统/Test.txt","r+");
    printf("\n");
    printf("题库中共有%d道题\n",length(L));
    printf("--------------------------------------------\n");
    
    if(NULL==fp)
        printf("File open error!");//要返回错误代码
    
    while(fscanf(fp,"%c",&c)!=EOF)
        printf("%c",c); //从文本中读入并在控制台打印出来
    
    fclose(fp);
}//输出所有题目

void back(List* L){
    int i;
    printf("\n--------------\n");
    printf("～1.返回主菜单\n");
    printf("～2.退出\n");
    printf(">>");
    scanf("%d", &i);
    if(i == 1){
        menu(L);
    }
    if(i == 2){
        exit(0);
    }
    printf("error!");
    back(L);
    
}
void search(List* L){
    FILE* readf;
    int total_ques;
    int count = 0;
    total_ques = length(L);
    readf = fopen("/Users/kendricklamar/Desktop/单项选择题标准化考试系统/Test.txt","r+");
    readfile(L, total_ques);
    printf("温馨提示：在输入汉字的时候,请先在您的电脑上的记事本中打出关键字,然后复制过来\n");
    printf("温馨提示：如果您直接在控制台或终端中输入汉字,很有可能匹配不出相关题目，因为您输入的汉字很有可能被系统转为了拼音...\n");
    printf("温馨提示：但是,如果以上情况没有发生,那么请忽略以上提示\n");
    printf("请输入要搜索的关键字：");
    char keyWord[20];
    scanf("%s",keyWord);
    printf("\n");
    char pattern1[30] = "(.*)";
    strcat(pattern1, keyWord);
    strcat(pattern1, "(.*)");
    regex_t reg;
    regmatch_t pmatch[total_ques];
    regcomp(&reg, pattern1, REG_EXTENDED);
    for(int i = 0; i < total_ques; i++){
        if (!regexec(&reg, L->List[i].content, total_ques, pmatch, 0)||!regexec(&reg, L->List[i].answer_A, total_ques, pmatch, 0)||!regexec(&reg, L->List[i].answer_B, total_ques, pmatch, 0)||!regexec(&reg, L->List[i].answer_C, total_ques, pmatch, 0)||!regexec(&reg, L->List[i].answer_D, total_ques, pmatch, 0)){
            printf("第%d题:%s\n",i+1,L->List[i].content);
            printf("%s\n",L->List[i].answer_A);
            printf("%s\n",L->List[i].answer_B);
            printf("%s\n",L->List[i].answer_C);
            printf("%s\n",L->List[i].answer_D);
            printf("%c\n",L->List[i].answer);
            count ++;
        }
    }
    printf("一共找到了相关题目%d道\n", count);
    regfree(&reg);
    fclose(readf);
}

int menu(List* L){
    int order_num;
    
    printf("******************************************\n");
    printf("*              1.录入试题库                *\n");
    printf("*              2.答题                     *\n");
    printf("*              3.打印题库所有题目           *\n");
    printf("*              4.打印错题                  *\n");
    printf("*              5.搜索题目                  *\n");
    printf("*              6.退出                     *\n");
    printf("******************************************\n");
    printf("请输入序号:");
    scanf("%d", &order_num);
    
    switch(order_num){
        case 1:
            add_question(L);
        case 2:
            response(L);
            back(L);
        case 3:
            sleep(1);
            showAll(L);
            back(L);
        case 4:
            record();
            back(L);
        case 5:
            search(L);
            back(L);
        case 6:
            exit(1);
        default:
            printf("无效序号,请重新输入!\n");
            menu(L);
    }
    return 1;
}

//保存题目
int savefile(List* L){
    FILE *fp;
    int i;
    fp = fopen("/Users/kendricklamar/Desktop/单项选择题标准化考试系统/Test.txt","r");
    if(fp == NULL){
        printf("File open error!");
        exit(0);
    }
    for(i = 0; i < L->len; i ++){
        fwrite(&L->List[i], sizeof(Question), 1, fp);
    }
    printf("保存成功!\n");
    fclose(fp);
    return 1;
}

//从文件读取题目
int readfile(List* L, int total_ques){
    FILE* readf;
    
    int i = 0;
    readf = fopen("/Users/kendricklamar/Desktop/单项选择题标准化考试系统/Test.txt","r+");
    
    if(!readf){
        printf("File open error!");
        exit(0);
    }
    for(i = 0; i < total_ques; i ++){
        fscanf(readf, "%s%s%s%s%s%s", L->List[i].content, L->List[i].answer_A, L->List[i].answer_B, L->List[i].answer_C, L->List[i].answer_D, &L->List[i].answer);
    }
    fclose(readf);
    return 1;
}


int main(void){
    List bb, *L = &bb;
    initList(L,1);
    printf("欢迎进入试题系统！\n");
    menu(L);
}




