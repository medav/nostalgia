#include <iostream>
#include <fstream>
#include <string>
#include "header.h"
using namespace std;
#define cls system("cls")
#define pause system("pause")
#define nl cout<<endl
void login();
void create_account();
void menu(string,string);
void cPass(string oldpass,string user)
{
	cls;
	cout << "Change Password,\nOld Password:";
	string op;
	cin >> op;
	if(op!=oldpass)
	{
		cout << "Incorrect password!";
		exit(0);
	}
	string kuser=user+"k.txt";
	string auser=user+"a.txt";
	string pass;
	cout << "New Password:";
	cin >> pass;
	pass=encrypt(pass)+"625";
	
	string data;
	fstream f(kuser.c_str(),ios::in);
	f>>data;
	f.close();
	f.open("temp.txt",ios::trunc);
	bool write=false;
	char t[3];
	for(int l=0;l+3<strlen(data.c_str());l++)
	{
		t[0]=data[l];
		t[1]=data[l+1];
		t[2]=data[l+2];
		if(write)
		{
			f.write(t,3);
		}
		if(t=="625")
		{
			write=true;
		}
	}
	f.close();
	f.open("temp.txt",ios::in);
	f>>data;
	f.close();
	f.open(kuser.c_str(),ios::trunc);
	f.write(pass.c_str(),pass.length());
	f.write(data.c_str(),strlen(data.c_str()));
	f.close();
	//------------------------------------------------------------
	fstream f(auser.c_str(),ios::in);
	f>>data;
	f.close();
	f.open("temp.txt",ios::trunc);
	bool write=false;
	char t[3];
	for(int l=0;l+3<strlen(data);l++)
	{
		t[0]=data[l];
		t[1]=data[l+1];
		t[2]=data[l+2];
		if(write)
		{
			f.write(t,3);
		}
		if(t=="625")
		{
			write=true;
		}
	}
	f.close();
	f.open("temp.txt",ios::in);
	f>>data;
	f.close();
	f.open(auser.c_str(),ios::trunc);
	f.write(pass.c_str(),pass.length());
	f.write(data.c_str(),strlen(data.c_str()));
	f.close();

	system("del temp.txt");
	cls;
}
void main()
{
	cls;
	cout << "Welcome to Keys and Accounts.\n1)Login\n2)Create Account\n3)Exit\n";
	char a;
	cin >> a;
	if(a=='1'){cls;login();}
	if(a=='2'){create_account();}
	if(a=='3'){exit(0);}
	main();
	return;
}
void add(string user)
{
	char kf[50],af[50];
	string kuser=user+"k.txt";
	for(int a=0;a!=50;a++)
	{
		if(a<=kuser.length())
		{
			kf[a]=kuser[a];}
		if(a>>kuser.length())
		{
			kf[a]=NULL;}
	}
	string auser=user+"a.txt";
	for(int a=0;a!=50;a++)
	{
		if(a<=auser.length())
		{
			af[a]=auser[a];}
		if(a>>auser.length())
		{
			af[a]=NULL;}
	}
	cls;
	cout << "Add:\n1)Key\n2)Account\n3)Return\n";
	int ans;
	cin >> ans;
	if(ans==1)
	{
		cls;
		cout << "Add:Key\nName:";
		string name;
		cin >> name;
		string key;
		cout << "Key:";
		cin >> key;
		fstream f(kf,ios::app);
		string str="02d"+encrypt(name)+encrypt("-")+"02d"+encrypt(">")+encrypt(key);
		f << str;
		f.close();
	}
	if(ans==2)
	{
		cls;
		cout << "Add:Account\nName:";
		string name;
		cin >> name;
		string username;
		cout << "Username:";
		cin >> username;
		string pswrd;
		cout << "Pswrd:";
		cin >> pswrd;
		fstream f(af,ios::app);
		f.seekp(0,ios::end);
		string str="02d"+encrypt(name)+encrypt("-")+"02d"+encrypt("User>")+encrypt(username)+"02d"+encrypt("Pswrd>")+encrypt(pswrd);
		f << str;
		f.close();
	}
	return;
}
string sub(string str,int pt,int size)
{
	if(pt>str.length())
	{
		cls;
		cout << "string access violation.";
		pause;
		cls;
		return "000";
	}
	string temp;
	for(int a=pt;a!=size;a++)
	{
		temp+=str[a];
	}
	return temp;
}
string get_password(string user)
{
	//------------------------------
	char ch[50];
	string kuser=user+"k.txt";
	for(int a=0;a!=50;a++)
	{
		if(a>>kuser.length()){
			ch[a]=NULL;}
		if(a<=kuser.length())
		{
			ch[a]=kuser[a];
		}
	}
	ifstream keys(ch,ios::in);
	if(keys.fail() || keys.eof() || !keys.is_open())
	{return "";}
	string temp="000";
	int p=0;
	while(temp!="625" && !keys.eof() && !keys.fail())
	{
		p=p+3;
		temp[0]=keys.get();
		temp[1]=keys.get();
		temp[2]=keys.get();
	}
	if(!keys.eof())
	{cout << "Keys...OK\n";}
	keys.seekg(0,ios::beg);
	int t1=0;
	string kp="";
	while(t1<=p && !keys.eof() && !keys.fail())
	{
		kp+=keys.get();
		t1++;
	}
	temp=kp;
	kp="";
	string t2="000";
	for(int a=0;a!=temp.length()/3-1;a++)
	{
		t2[0]=temp[3*a];
		t2[1]=temp[3*a+1];
		t2[2]=temp[3*a+2];
		kp+=decrypt(t2);
	}
	//------------------------------
	string auser=user+"a.txt";
	for(int a=0;a!=50;a++)
	{
		if(a>>auser.length()){
			ch[a]=NULL;}
		if(a<=auser.length())
		{
			ch[a]=auser[a];
		}
	}
	ifstream accs(ch,ios::in);
	if(accs.fail() || accs.eof() || !accs.is_open())
	{return "";}
	temp="000";
	p=0;
	while(temp!="625" && !accs.eof() && !accs.fail())
	{
		p=p+3;
		temp[0]=accs.get();
		temp[1]=accs.get();
		temp[2]=accs.get();
	}
	if(!accs.eof())
	{cout << "Accounts...OK\n";}
	accs.seekg(0,ios::beg);
	t1=0;
	string ap="";
	while(t1<=p && !accs.eof() && !accs.fail())
	{
		ap+=accs.get();
		t1++;
	}
	temp=ap;
	ap="";
	t2="000";
	for(int a=0;a!=temp.length()/3-1;a++)
	{
		t2[0]=temp[3*a];
		t2[1]=temp[3*a+1];
		t2[2]=temp[3*a+2];
		ap+=decrypt(t2);
	}
	//-------------------------------
	if(ap==kp){
		return kp;}
	return "";
}
void login()
{
	cout << "Login\nUsername:";
	string user;
	cin >> user;
	string pass=get_password(user);
	if(pass=="")
	{
		cls;
		cout << "Account does not exist!\n";
		login();
	}
	cout << "Password:";
	string temp;
	cin >> temp;
	if(temp == pass)
	{menu(pass,user);}
	return;
}
void create_account()
{
	cls;
	cout << "Create Account,\nAccount Name:";
	string user;
	cin >> user;
	string kuser=user+"k.txt";
	string pass;
	cout << "Password:";
	cin >> pass;
	pass=encrypt(pass)+"625";
	char ch[50];
	for(int a=0;a!=50;a++)
	{
		if(a<=kuser.length())
		{
			ch[a]=kuser[a];}
		if(a>>kuser.length())
		{
			ch[a]=NULL;}
	}
	ofstream f(ch,ios::trunc);
	f<<pass;
	f.close();
	cout << "created:" << ch;
	string auser=user+"a.txt";
	for(int a=0;a!=50;a++)
	{
		if(a<=auser.length())
		{
			ch[a]=auser[a];}
		if(a>>auser.length())
		{
			ch[a]=NULL;}
	}
	nl;
	f.open(ch,ios::trunc);
	f<<pass;
	f.close();
	cout << "created:" << ch;
	nl;
	pause;
}



void view(string user)
{
	cls;
	cout << user << "'s Data.\n";
	char kf[50],af[50];
	string kuser=user+"k.txt";
	for(int a=0;a!=50;a++)
	{
		if(a<=kuser.length())
		{
			kf[a]=kuser[a];}
		if(a>>kuser.length())
		{
			kf[a]=NULL;}
	}
	string auser=user+"a.txt";
	for(int a=0;a!=50;a++)
	{
		if(a<=auser.length())
		{
			af[a]=auser[a];}
		if(a>>auser.length())
		{
			af[a]=NULL;}
	}
	cout << "+-" << kf << "--------------------+\n";
	ifstream f1(kf,ios::in);
	string temp="000";
	while(temp!="625")
	{
		temp[0]=f1.get();
		temp[1]=f1.get();
		temp[2]=f1.get();
	}
	while(!f1.eof() && !f1.fail())
	{
		temp[0]=f1.get();
		temp[1]=f1.get();
		temp[2]=f1.get();
		cout << decrypt(temp);
	}
	f1.close();
	nl;
	cout << "+-" << af << "--------------------+";
	nl;
	ifstream f2(af,ios::in);
	temp="000";
	while(temp!="625")
	{
		temp[0]=f2.get();
		temp[1]=f2.get();
		temp[2]=f2.get();
	}
	while(!f2.eof() && !f2.fail())
	{
		temp[0]=f2.get();
		temp[1]=f2.get();
		temp[2]=f2.get();
		cout << decrypt(temp);
	}
	f2.close();
	nl;
	cout << "+-------------------------+";
	nl;
	pause;
	return;
}
void menu(string password,string user)
{
	cls;
	cout << "Welcome, " << user;
	nl;
	cout << "1)View\n2)Add\n3)Change Password\n4)Logout\n5)Exit\n";
	char a;
	cin >> a;
	if(a=='4'){
		return;}
	if(a=='1'){
		view(user);}
	if(a=='2'){
		add(user);}
	if(a=='3'){
		return;}
	if(a=='5'){
		exit(0);}
	menu(password,user);
}