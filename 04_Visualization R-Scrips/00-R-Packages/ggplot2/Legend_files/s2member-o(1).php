(function(a){if(typeof a.sprintf!=="function"){a.sprintf=function(){var g=/%%|%(\d+\$)?([-+\'#0 ]*)(\*\d+\$|\*|\d+)?(\.(\*\d+\$|\*|\d+))?([scboxXuidfegEG])/g;var h=arguments,f=0,k=h[f++];var b=function(o,i,l,n){if(!l){l=" "}var m=(o.length>=i)?"":Array(1+i-o.length>>>0).join(l);return n?o+m:m+o};var c=function(n,m,q,i,l,p){var o=i-n.length;if(o>0){if(q||!l){n=b(n,i,p,q)}else{n=n.slice(0,m.length)+b("",o,"0",true)+n.slice(m.length)}}return n};var j=function(q,p,o,r,l,i,n){var m=q>>>0;o=o&&m&&{"2":"0b","8":"0","16":"0x"}[p]||"";q=o+b(m.toString(p),i||0,"0",false);return c(q,o,r,l,n)};var e=function(n,p,l,i,m,o){if(i!=null){n=n.slice(0,i)}return c(n,"",p,l,m,o)};var d=function(A,n,o,s,C,x,m){var i;var w;var l;var B;var u;if(A=="%%"){return"%"}var t=false,p="",r=false,z=false,y=" ";var q=o.length;for(var v=0;o&&v<q;v++){switch(o.charAt(v)){case" ":p=" ";break;case"+":p="+";break;case"-":t=true;break;case"'":y=o.charAt(v+1);break;case"0":r=true;break;case"#":z=true;break}}if(!s){s=0}else{if(s=="*"){s=+h[f++]}else{if(s.charAt(0)=="*"){s=+h[s.slice(1,-1)]}else{s=+s}}}if(s<0){s=-s;t=true}if(!isFinite(s)){throw new Error("sprintf: (minimum-)width must be finite")}if(!x){x="fFeE".indexOf(m)>-1?6:(m=="d")?0:undefined}else{if(x=="*"){x=+h[f++]}else{if(x.charAt(0)=="*"){x=+h[x.slice(1,-1)]}else{x=+x}}}u=n?h[n.slice(0,-1)]:h[f++];switch(m){case"s":return e(String(u),t,s,x,r,y);case"c":return e(String.fromCharCode(+u),t,s,x,r);case"b":return j(u,2,z,t,s,x,r);case"o":return j(u,8,z,t,s,x,r);case"x":return j(u,16,z,t,s,x,r);case"X":return j(u,16,z,t,s,x,r).toUpperCase();case"u":return j(u,10,z,t,s,x,r);case"i":case"d":i=(+u)|0;w=i<0?"-":p;u=w+b(String(Math.abs(i)),x,"0",false);return c(u,w,t,s,r);case"e":case"E":case"f":case"F":case"g":case"G":i=+u;w=i<0?"-":p;l=["toExponential","toFixed","toPrecision"]["efg".indexOf(m.toLowerCase())];B=["toString","toUpperCase"]["eEfFgG".indexOf(m)%2];u=w+Math.abs(i)[l](x);return c(u,w,t,s,r)[B]();default:return A}};return k.replace(g,d)}}})(jQuery);
var S2MEMBER_CURRENT_USER_IS_LOGGED_IN = false,S2MEMBER_CURRENT_USER_IS_LOGGED_IN_AS_MEMBER = false,S2MEMBER_CURRENT_USER_FIRST_NAME = '',S2MEMBER_CURRENT_USER_LAST_NAME = '',S2MEMBER_CURRENT_USER_LOGIN = '',S2MEMBER_CURRENT_USER_EMAIL = '',S2MEMBER_CURRENT_USER_DOWNLOADS_ALLOWED = 0,S2MEMBER_CURRENT_USER_DOWNLOADS_ALLOWED_IS_UNLIMITED = false,S2MEMBER_CURRENT_USER_DOWNLOADS_CURRENTLY = 0,S2MEMBER_CURRENT_USER_DOWNLOADS_ALLOWED_DAYS = 0;
jQuery(document).ready(function(d){window.ws_plugin__s2member_skip_all_file_confirmations=window.ws_plugin__s2member_skip_all_file_confirmations||false;var c='',a='s2member-files',b=ws_plugin__s2member_skip_all_file_confirmations?true:false,e=[];window.ws_plugin__s2member_passwordMinLength=function(){return parseInt("8")};window.ws_plugin__s2member_passwordMinStrengthCode=function(){return"good"};window.ws_plugin__s2member_passwordMinStrengthLabel=function(){return"`good` or `strong` (i.e., use numbers, letters, and mixed caSe)"};window.ws_plugin__s2member_passwordMinStrengthScore=function(){return parseInt("30")};window.ws_plugin__s2member_passwordStrengthMeter=function(j,g,i){var h=0,f=ws_plugin__s2member_passwordMinLength();j=String(j);g=String(g);if(j!=g&&g.length>0){return"mismatch"}else{if(j.length<1){return"empty"}else{if(j.length<f){return"short"}}}if(j.match(/[0-9]/)){h+=10}if(j.match(/[a-z]/)){h+=10}if(j.match(/[A-Z]/)){h+=10}if(j.match(/[^0-9a-zA-Z]/)){h=h===30?h+20:h+10}if(i){return h}if(h<30){return"weak"}if(h<50){return"good"}return"strong"};window.ws_plugin__s2member_passwordStrength=function(h,k,i,g){if(h instanceof jQuery&&k instanceof jQuery&&i instanceof jQuery&&g instanceof jQuery){var j={empty:'Strength indicator',"short":'Very weak',weak:'Weak',good:'Good',strong:'Strong',mismatch:'Mismatch'};g.removeClass("ws-plugin--s2member-password-strength-short");g.removeClass("ws-plugin--s2member-password-strength-weak");g.removeClass("ws-plugin--s2member-password-strength-good");g.removeClass("ws-plugin--s2member-password-strength-strong");g.removeClass("ws-plugin--s2member-password-strength-mismatch");g.removeClass("ws-plugin--s2member-password-strength-empty");var f=ws_plugin__s2member_passwordStrengthMeter(k.val(),i.val());g.addClass("ws-plugin--s2member-password-strength-"+f).html(j[f])}};window.ws_plugin__s2member_validationErrors=function(r,q,g,m,l){if(typeof r==="string"&&r&&typeof q==="object"&&typeof g==="object"){if(typeof q.tagName==="string"&&/^(input|textarea|select)$/i.test(q.tagName)&&!q.disabled){var t=q.tagName.toLowerCase(),p=d(q),o=d.trim(p.attr("type")).toLowerCase(),f=d.trim(p.attr("name")),s=p.val();m=(typeof m==="boolean")?m:(p.attr("aria-required")==="true"),l=(typeof l==="string")?l:d.trim(p.attr("data-expected"));var k=('23'>0);var i=new RegExp('^(network|club|online|pro)@',"i");if(t==="input"&&o==="checkbox"&&/\[\]$/.test(f)){if(typeof q.id==="string"&&/-0$/.test(q.id)){if(m&&!d('input[name="'+ws_plugin__s2member_escjQAttr(f)+'"]:checked',g).length){return r+'\nPlease check at least one of the boxes.'}}}else{if(t==="input"&&o==="checkbox"){if(m&&!q.checked){return r+'\nRequired. This box must be checked.'}}else{if(t==="input"&&o==="radio"){if(typeof q.id==="string"&&/-0$/.test(q.id)){if(m&&!d('input[name="'+ws_plugin__s2member_escjQAttr(f)+'"]:checked',g).length){return r+'\nPlease select one of the options.'}}}else{if(t==="select"&&p.attr("multiple")){if(m&&(!(s instanceof Array)||!s.length)){return r+'\nPlease select at least one of the options.'}}else{if(typeof s!=="string"||(m&&!(s=d.trim(s)).length)){return r+'\nThis is a required field, please try again.'}else{if((s=d.trim(s)).length&&((t==="input"&&/^(text|password)$/i.test(o))||t==="textarea")&&typeof l==="string"&&l.length){if(l==="numeric-wp-commas"&&(!/^[0-9\.,]+$/.test(s)||isNaN(s.replace(/,/g,"")))){return r+'\nMust be numeric (with or without decimals, commas allowed).'}else{if(l==="numeric"&&(!/^[0-9\.]+$/.test(s)||isNaN(s))){return r+'\nMust be numeric (with or without decimals, no commas).'}else{if(l==="integer"&&(!/^[0-9]+$/.test(s)||isNaN(s))){return r+'\nMust be an integer (a whole number, without any decimals).'}else{if(l==="integer-gt-0"&&(!/^[0-9]+$/.test(s)||isNaN(s)||s<=0)){return r+'\nMust be an integer > 0 (whole number, no decimals, greater than 0).'}else{if(l==="float"&&(!/^[0-9\.]+$/.test(s)||!/[0-9]/.test(s)||!/\./.test(s)||isNaN(s))){return r+'\nMust be a float (floating point number, decimals required).'}else{if(l==="float-gt-0"&&(!/^[0-9\.]+$/.test(s)||!/[0-9]/.test(s)||!/\./.test(s)||isNaN(s)||s<=0)){return r+'\nMust be a float > 0 (floating point number, decimals required, greater than 0).'}else{if(l==="date"&&!/^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/.test(s)){return r+'\nMust be a date (required date format: dd/mm/yyyy).'}else{if(l==="email"&&!/^[a-zA-Z0-9_!#$%&*+=?`{}~|\/\^\'\-]+(?:\.?[a-zA-Z0-9_!#$%&*+=?`{}~|\/\^\'\-]+)*@[a-zA-Z0-9]+(?:\-*[a-zA-Z0-9]+)*(?:\.[a-zA-Z0-9]+(?:\-*[a-zA-Z0-9]+)*)*(?:\.[a-zA-Z][a-zA-Z0-9]+)?$/.test(s)){return r+'\nMust be a valid email address.'}else{if(l==="email"&&k&&i.test(s)){return r+"\n"+d.sprintf('Please use a personal email address.\nAddresses like <%s@> are problematic.',s.split("@")[0])}else{if(l==="url"&&!/^https?\:\/\/.+$/i.test(s)){return r+'\nMust be a full URL (starting with http or https).'}else{if(l==="domain"&&!/^[a-zA-Z0-9]+(?:\-*[a-zA-Z0-9]+)*(?:\.[a-zA-Z0-9]+(?:\-*[a-zA-Z0-9]+)*)*(?:\.[a-zA-Z][a-zA-Z0-9]+)?$/.test(s)){return r+'\nMust be a domain name (domain name only, without http).'}else{if(l==="phone"&&(!/^[0-9 ()\-]+$/.test(s)||s.replace(/[^0-9]+/g,"").length!==10)){return r+'\nMust be a phone # (10 digits w/possible hyphens, spaces, brackets).'}else{if(l==="uszip"&&!/^[0-9]{5}(?:\-[0-9]{4})?$/.test(s)){return r+'\nMust be a US zipcode (5-9 digits w/ possible hyphen).'}else{if(l==="cazip"&&!/^[0-9A-Z]{3} ?[0-9A-Z]{3}$/i.test(s)){return r+'\nMust be a Canadian zipcode (6 alpha-numerics w/possible space).'}else{if(l==="uczip"&&!/^[0-9]{5}(?:\-[0-9]{4})?$/.test(s)&&!/^[0-9A-Z]{3} ?[0-9A-Z]{3}$/i.test(s)){return r+'\nMust be a zipcode (either a US or Canadian zipcode).'}else{if(/^alphanumerics\-spaces\-punctuation\-[0-9]+(?:\-e)?$/.test(l)&&!/^[a-z 0-9\/\\\\,.?:;"\'{}[\]\^|+=_()*&%$#@!`~\-]+$/i.test(s)){return r+'\nPlease use alphanumerics, spaces & punctuation only.'}else{if(/^alphanumerics\-spaces\-[0-9]+(?:\-e)?$/.test(l)&&!/^[a-z 0-9]+$/i.test(s)){return r+'\nPlease use alphanumerics & spaces only.'}else{if(/^alphanumerics\-punctuation\-[0-9]+(?:\-e)?$/.test(l)&&!/^[a-z0-9\/\\\\,.?:;"\'{}[\]\^|+=_()*&%$#@!`~\-]+$/i.test(s)){return r+'\nPlease use alphanumerics & punctuation only (no spaces).'}else{if(/^alphanumerics\-[0-9]+(?:\-e)?$/.test(l)&&!/^[a-z0-9]+$/i.test(s)){return r+'\nPlease use alphanumerics only (no spaces/punctuation).'}else{if(/^alphabetics\-[0-9]+(?:\-e)?$/.test(l)&&!/^[a-z]+$/i.test(s)){return r+'\nPlease use alphabetics only (no digits/spaces/punctuation).'}else{if(/^numerics\-[0-9]+(?:\-e)?$/.test(l)&&!/^[0-9]+$/i.test(s)){return r+'\nPlease use numeric digits only.'}else{if(/^(?:any|alphanumerics\-spaces\-punctuation|alphanumerics\-spaces|alphanumerics\-punctuation|alphanumerics|alphabetics|numerics)\-[0-9]+(?:\-e)?$/.test(l)){var n=l.split("-"),h=Number(n[1]),j=(n.length>2&&n[2]==="e");if(j&&s.length!==h){return r+"\n"+d.sprintf('Must be exactly %s %s.',h,((n[0]==="numerics")?((h===1)?'digit':'digits'):((h===1)?'character':'characters')))}else{if(s.length<h){return r+"\n"+d.sprintf('Must be at least %s %s.',h,((n[0]==="numerics")?((h===1)?'digit':'digits'):((h===1)?'character':'characters')))}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}return""};window.ws_plugin__s2member_animateProcessing=function(g,f){if(f){d(g).removeClass("ws-plugin--s2member-animate-processing")}else{d(g).addClass("ws-plugin--s2member-animate-processing")}};window.ws_plugin__s2member_escAttr=window.ws_plugin__s2member_escHtml=function(f){if(/[&\<\>"']/.test(f=String(f))){f=f.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;"),f=f.replace(/"/g,"&quot;").replace(/'/g,"&#039;")}return f};window.ws_plugin__s2member_escjQAttr=function(f){return String(f).replace(/([.:\[\]])/g,"\\$1")};if(!b&&S2MEMBER_CURRENT_USER_IS_LOGGED_IN&&S2MEMBER_CURRENT_USER_DOWNLOADS_CURRENTLY<S2MEMBER_CURRENT_USER_DOWNLOADS_ALLOWED){d('a[href*="s2member_file_download="], a[href*="/s2member-files/"], a[href^="s2member-files/"], a[href*="/'+a.replace(/([\:\.\[\]])/g,"\\$1")+'/"], a[href^="'+a.replace(/([\:\.\[\]])/g,"\\$1")+'/"]').click(function(){if(!/s2member[_\-]file[_\-]download[_\-]key[\=\-].+/i.test(this.href)){var f='— Confirm File Download —\n\n';f+=d.sprintf('You`ve downloaded %s protected %s in the last %s.',S2MEMBER_CURRENT_USER_DOWNLOADS_CURRENTLY,((S2MEMBER_CURRENT_USER_DOWNLOADS_CURRENTLY===1)?'file':'files'),((S2MEMBER_CURRENT_USER_DOWNLOADS_ALLOWED_DAYS===1)?'24 hours':d.sprintf('%s days',S2MEMBER_CURRENT_USER_DOWNLOADS_ALLOWED_DAYS)))+"\n\n";f+=(S2MEMBER_CURRENT_USER_DOWNLOADS_ALLOWED_IS_UNLIMITED)?'You`re entitled to UNLIMITED downloads though (so, no worries).':d.sprintf('You`re entitled to %s unique %s %s.',S2MEMBER_CURRENT_USER_DOWNLOADS_ALLOWED,((S2MEMBER_CURRENT_USER_DOWNLOADS_ALLOWED===1)?'download':'downloads'),((S2MEMBER_CURRENT_USER_DOWNLOADS_ALLOWED_DAYS===1)?'each day':d.sprintf('every %s-day period',S2MEMBER_CURRENT_USER_DOWNLOADS_ALLOWED_DAYS)));if((/s2member[_\-]skip[_\-]confirmation/i.test(this.href)&&!/s2member[_\-]skip[_\-]confirmation[\=\-](0|no|false)/i.test(this.href))||confirm(f)){if(d.inArray(this.href,e)===-1){S2MEMBER_CURRENT_USER_DOWNLOADS_CURRENTLY++,e.push(this.href)}return true}return false}return true})}if(!/\/wp-admin([\/?#]|$)/i.test(location.href)){d("input#ws-plugin--s2member-profile-password1, input#ws-plugin--s2member-profile-password2").on("keyup initialize.s2",function(){ws_plugin__s2member_passwordStrength(d("input#ws-plugin--s2member-profile-login"),d("input#ws-plugin--s2member-profile-password1"),d("input#ws-plugin--s2member-profile-password2"),d("div#ws-plugin--s2member-profile-password-strength"))}).trigger("initialize.s2");d("form#ws-plugin--s2member-profile").submit(function(){var h=this,g="",f="",l="",j=d("input#ws-plugin--s2member-profile-password1",h),i=d("input#ws-plugin--s2member-profile-password2",h);var k=d("input#ws-plugin--s2member-profile-submit",h);d(":input",h).each(function(){var m=d.trim(d(this).attr("id")).replace(/---[0-9]+$/g,"");if(m&&(g=d.trim(d('label[for="'+m+'"]',h).first().children("strong").first().text().replace(/[\r\n\t]+/g," ")))){if(f=ws_plugin__s2member_validationErrors(g,this,h)){l+=f+"\n\n"}}});if(l=d.trim(l)){alert('— Oops, you missed something: —\n\n'+l);return false}else{if(d.trim(j.val())&&d.trim(j.val())!==d.trim(i.val())){alert('— Oops, you missed something: —\n\nPasswords do not match up. Please try again.');return false}else{if(d.trim(j.val())&&d.trim(j.val()).length<ws_plugin__s2member_passwordMinLength()){alert('— Oops, you missed something: —\n\nPassword MUST be at least 8 characters. Please try again.');return false}else{if(d.trim(j.val())&&ws_plugin__s2member_passwordStrengthMeter(d.trim(j.val()),d.trim(i.val()),true)<ws_plugin__s2member_passwordMinStrengthScore()){alert('— Oops, you missed something: —\n\nPassword strength MUST be `good` or `strong` (i.e., use numbers, letters, and mixed caSe). Please try again.');return false}}}}ws_plugin__s2member_animateProcessing(k);return true})}if(/\/wp-signup\.php/i.test(location.href)){d("div#content > div.mu_register > form#setupform").submit(function(){var h=this,g="",f="",j="",i=d('p.submit input[type="submit"]',h);d("input#user_email",h).attr("data-expected","email");d("input#user_name, input#user_email, input#blogname, input#blog_title, input#captcha_code",h).attr({"aria-required":"true"});d(":input",h).each(function(){var k=d.trim(d(this).attr("id")).replace(/---[0-9]+$/g,"");if(k&&(g=d.trim(d('label[for="'+k+'"]',h).first().text().replace(/[\r\n\t]+/g," ")))){if(f=ws_plugin__s2member_validationErrors(g,this,h)){j+=f+"\n\n"}}});if(j=d.trim(j)){alert('— Oops, you missed something: —\n\n'+j);return false}ws_plugin__s2member_animateProcessing(i);return true})}if(/\/wp-login\.php/i.test(location.href)){d("div#login > form#registerform input#user_login").attr("tabindex","10");d("div#login > form#registerform input#user_email").attr("tabindex","20");d("div#login > form#registerform input#wp-submit").attr("tabindex","1000");d("input#ws-plugin--s2member-custom-reg-field-user-pass1, input#ws-plugin--s2member-custom-reg-field-user-pass2").on("keyup initialize.s2",function(){ws_plugin__s2member_passwordStrength(d("input#user_login"),d("input#ws-plugin--s2member-custom-reg-field-user-pass1"),d("input#ws-plugin--s2member-custom-reg-field-user-pass2"),d("div#ws-plugin--s2member-custom-reg-field-user-pass-strength"))}).trigger("initialize.s2");d("div#login > form#registerform").submit(function(){var h=this,g="",f="",l="",k=d('input#ws-plugin--s2member-custom-reg-field-user-pass1[aria-required="true"]',h),i=d("input#ws-plugin--s2member-custom-reg-field-user-pass2",h),j=d("input#wp-submit",h);d("input#user_email",h).attr("data-expected","email");d("input#user_login, input#user_email, input#captcha_code",h).attr({"aria-required":"true"});d(":input",h).each(function(){var m=d.trim(d(this).attr("id")).replace(/---[0-9]+$/g,"");if(d.inArray(m,["user_login","user_email","captcha_code"])!==-1){if((g=d.trim(d(this).parent("label").text().replace(/[\r\n\t]+/g," ")))){if(f=ws_plugin__s2member_validationErrors(g,this,h)){l+=f+"\n\n"}}}else{if(m&&(g=d.trim(d('label[for="'+m+'"]',h).first().children("span").first().text().replace(/[\r\n\t]+/g," ")))){if(f=ws_plugin__s2member_validationErrors(g,this,h)){l+=f+"\n\n"}}}});if(l=d.trim(l)){alert('— Oops, you missed something: —\n\n'+l);return false}else{if(k.length&&d.trim(k.val())!==d.trim(i.val())){alert('— Oops, you missed something: —\n\nPasswords do not match up. Please try again.');return false}else{if(k.length&&d.trim(k.val()).length<ws_plugin__s2member_passwordMinLength()){alert('— Oops, you missed something: —\n\nPassword MUST be at least 8 characters. Please try again.');return false}else{if(k.length&&ws_plugin__s2member_passwordStrengthMeter(d.trim(k.val()),d.trim(i.val()),true)<ws_plugin__s2member_passwordMinStrengthScore()){alert('— Oops, you missed something: —\n\nPassword strength MUST be `good` or `strong` (i.e., use numbers, letters, and mixed caSe). Please try again.');return false}}}}ws_plugin__s2member_animateProcessing(j);return true})}if(/\/wp-admin\/(?:user\/)?profile\.php/i.test(location.href)){d("form#your-profile").submit(function(){var h=this,g="",f="",i="";d("input#email",h).attr("data-expected","email");d(':input[id^="ws-plugin--s2member-profile-"]',h).each(function(){var j=d.trim(d(this).attr("id")).replace(/---[0-9]+$/g,"");if(j&&(g=d.trim(d('label[for="'+j+'"]',h).first().text().replace(/[\r\n\t]+/g," ")))){if(f=ws_plugin__s2member_validationErrors(g,this,h)){i+=f+"\n\n"}}});if(i=d.trim(i)){alert('— Oops, you missed something: —\n\n'+i);return false}return true})}if(c){d("body.registration form div#ws-plugin--s2member-custom-reg-fields-4bp-section").closest("form").submit(function(){var h=this,g="",f="",i="";d("input#signup_email",h).attr("data-expected","email");d("input#signup_username, input#signup_email, input#signup_password, input#field_1",h).attr({"aria-required":"true"});d(":input",h).each(function(){var j=d.trim(d(this).attr("id")).replace(/---[0-9]+$/g,"");if(j&&(g=d.trim(d('label[for="'+j+'"]',h).first().text().replace(/[\r\n\t]+/g," ")))){if(f=ws_plugin__s2member_validationErrors(g,this,h)){i+=f+"\n\n"}}});if(i=d.trim(i)){alert('— Oops, you missed something: —\n\n'+i);return false}return true});d("body.logged-in.profile.profile-edit :input.ws-plugin--s2member-profile-field-4bp").closest("form").submit(function(){var h=this,g="",f="",i="";d("input#field_1",h).attr({"aria-required":"true"});d(":input",h).each(function(){var j=d.trim(d(this).attr("id")).replace(/---[0-9]+$/g,"");if(j&&(g=d.trim(d('label[for="'+j+'"]',h).first().text().replace(/[\r\n\t]+/g," ")))){if(f=ws_plugin__s2member_validationErrors(g,this,h)){i+=f+"\n\n"}}});if(i=d.trim(i)){alert('— Oops, you missed something: —\n\n'+i);return false}return true})}});
var S2MEMBER_PRO_VERSION = '210208';
jQuery(document).ready(function(a){});
var S2MEMBER_PRO_PAYPAL_GATEWAY = true;
jQuery(document).ready(function(A){var e,r,k,n,q,L,z,x={"aria-required":"true"},b={"aria-required":"false"},B={disabled:"disabled"},i={"aria-required":"false",disabled:"disabled"};z=new Image(),z.src='https://www.datanovia.com/en/wp-content/plugins/s2member/src/images/ajax-loader.gif';if(A("form.s2member-pro-paypal-registration-form").length>1||A("form.s2member-pro-paypal-checkout-form").length>1||A("form.s2member-pro-paypal-sp-checkout-form").length>1){return alert("Detected more than one s2Member Pro-Form.\n\nPlease use only ONE s2Member Pro-Form Shortcode on each Post/Page. Attempting to serve more than one Pro-Form on each Post/Page (even w/ DHTML) may result in unexpected/broken functionality.")}if((e=A("form#s2member-pro-paypal-cancellation-form")).length===1){var O="div#s2member-pro-paypal-cancellation-form-captcha-section",o="div#s2member-pro-paypal-cancellation-form-submission-section",w=A(o+" button#s2member-pro-paypal-cancellation-submit");ws_plugin__s2member_animateProcessing(w,"reset"),w.removeAttr("disabled");e.submit(function(){var U=this,S="",R="",V="";var T=A(O+" input#recaptcha_response_field, "+O+" #g-recaptcha-response");A(":input",U).each(function(){var W=A.trim(A(this).attr("id")).replace(/---[0-9]+$/g,"");if(W&&(S=A.trim(A('label[for="'+W+'"]',U).first().children("span").first().text().replace(/[\r\n\t]+/g," ")))){if(R=ws_plugin__s2member_validationErrors(S,this,U)){V+=R+"\n\n"}}});if(V=A.trim(V)){alert('— Oops, you missed something: —\n\n'+V);return false}else{if(T.length&&!T.val()){alert('— Oops, you missed something: —\n\nSecurity Verification missing. Please try again.');return false}}w.attr(B),ws_plugin__s2member_animateProcessing(w);return true})}else{if((r=A("form#s2member-pro-paypal-update-form")).length===1){var u,v="div#s2member-pro-paypal-update-form-billing-method-section",I="div#s2member-pro-paypal-update-form-billing-address-section",m=v+' input[name="s2member_pro_paypal_update[card_type]"]',O="div#s2member-pro-paypal-update-form-captcha-section",o="div#s2member-pro-paypal-update-form-submission-section",w=A(o+" button#s2member-pro-paypal-update-submit");ws_plugin__s2member_animateProcessing(w,"reset"),w.removeAttr("disabled");(u=function(R){var S=A(m+":checked").val();if(A.inArray(S,["Visa","MasterCard","Amex","Discover"])!==-1){A(v+" > div.s2member-pro-paypal-update-form-div").show();A(v+" > div.s2member-pro-paypal-update-form-div :input").attr(x);A(v+" > div#s2member-pro-paypal-update-form-card-start-date-issue-number-div").hide();A(v+" > div#s2member-pro-paypal-update-form-card-start-date-issue-number-div :input").attr(b);A(I+" > div.s2member-pro-paypal-update-form-div").show();A(I+" > div.s2member-pro-paypal-update-form-div :input").attr(x);A(I).show(),(R)?A(v+" input#s2member-pro-paypal-update-card-number").focus():null}else{if(A.inArray(S,["Maestro","Solo"])!==-1){A(v+" > div.s2member-pro-paypal-update-form-div").show();A(v+" > div.s2member-pro-paypal-update-form-div :input").attr(x);A(I+" > div.s2member-pro-paypal-update-form-div").show();A(I+" > div.s2member-pro-paypal-update-form-div :input").attr(x);A(I).show(),(R)?A(v+" input#s2member-pro-paypal-update-card-number").focus():null}else{if(!S){A(v+" > div.s2member-pro-paypal-update-form-div").hide();A(v+" > div.s2member-pro-paypal-update-form-div :input").attr(b);A(v+" > div#s2member-pro-paypal-update-form-card-type-div").show();A(v+" > div#s2member-pro-paypal-update-form-card-type-div :input").attr(x);A(I+" > div.s2member-pro-paypal-update-form-div").hide();A(I+" > div.s2member-pro-paypal-update-form-div :input").attr(b);A(I).hide(),(R)?A(o+" button#s2member-pro-paypal-update-submit").focus():null}}}})();A(m).click(u).change(u);r.submit(function(){var U=this,S="",R="",V="";var T=A(O+" input#recaptcha_response_field, "+O+" #g-recaptcha-response");if(!A(m+":checked").val()){alert('Please choose a Billing Method.');return false}A(":input",U).each(function(){var W=A.trim(A(this).attr("id")).replace(/---[0-9]+$/g,"");if(W&&(S=A.trim(A('label[for="'+W.replace(/-(month|year)/,"")+'"]',U).first().children("span").first().text().replace(/[\r\n\t]+/g," ")))){if(R=ws_plugin__s2member_validationErrors(S,this,U)){V+=R+"\n\n"}}});if(V=A.trim(V)){alert('— Oops, you missed something: —\n\n'+V);return false}else{if(T.length&&!T.val()){alert('— Oops, you missed something: —\n\nSecurity Verification missing. Please try again.');return false}}w.attr(B),ws_plugin__s2member_animateProcessing(w);return true})}else{if((k=A("form#s2member-pro-paypal-registration-form")).length===1){var j,M,s,a="div#s2member-pro-paypal-registration-form-options-section",G="div#s2member-pro-paypal-registration-form-description-section",N="div#s2member-pro-paypal-registration-form-registration-section",O="div#s2member-pro-paypal-registration-form-captcha-section",o="div#s2member-pro-paypal-registration-form-submission-section",l=o+" input#s2member-pro-paypal-registration-nonce",w=A(o+" button#s2member-pro-paypal-registration-submit");ws_plugin__s2member_animateProcessing(w,"reset"),w.removeAttr("disabled");(j=function(R){if(!A(a+" select#s2member-pro-paypal-registration-options option").length){A(a).hide();A(G).show()}else{A(a).show();A(G).hide();A(a+" select#s2member-pro-paypal-registration-options").change(function(){A(l).val("option");k.attr("action",k.attr("action").replace(/#.*$/,"")+"#s2p-form");k.submit()})}})();(M=function(R){if(A(o+" input#s2member-pro-paypal-registration-names-not-required-or-not-possible").length){A(N+" > div#s2member-pro-paypal-registration-form-first-name-div").hide();A(N+" > div#s2member-pro-paypal-registration-form-first-name-div :input").attr(i);A(N+" > div#s2member-pro-paypal-registration-form-last-name-div").hide();A(N+" > div#s2member-pro-paypal-registration-form-last-name-div :input").attr(i)}})();(s=function(R){if(A(o+" input#s2member-pro-paypal-registration-password-not-required-or-not-possible").length){A(N+" > div#s2member-pro-paypal-registration-form-password-div").hide();A(N+" > div#s2member-pro-paypal-registration-form-password-div :input").attr(i)}})();A(N+" > div#s2member-pro-paypal-registration-form-password-div :input").on("keyup initialize.s2",function(){ws_plugin__s2member_passwordStrength(A(N+" input#s2member-pro-paypal-registration-username"),A(N+" input#s2member-pro-paypal-registration-password1"),A(N+" input#s2member-pro-paypal-registration-password2"),A(N+" div#s2member-pro-paypal-registration-form-password-strength"))}).trigger("initialize.s2");k.submit(function(){if(A.inArray(A(l).val(),["option"])===-1){var U=this,S="",R="",X="";var T=A(O+" input#recaptcha_response_field, "+O+" #g-recaptcha-response");var W=A(N+' input#s2member-pro-paypal-registration-password1[aria-required="true"]');var V=A(N+" input#s2member-pro-paypal-registration-password2");A(":input",U).each(function(){var Y=A.trim(A(this).attr("id")).replace(/---[0-9]+$/g,"");if(Y&&(S=A.trim(A('label[for="'+Y+'"]',U).first().children("span").first().text().replace(/[\r\n\t]+/g," ")))){if(R=ws_plugin__s2member_validationErrors(S,this,U)){X+=R+"\n\n"}}});if(X=A.trim(X)){alert('— Oops, you missed something: —\n\n'+X);return false}else{if(W.length&&A.trim(W.val())!==A.trim(V.val())){alert('— Oops, you missed something: —\n\nPasswords do not match up. Please try again.');return false}else{if(W.length&&A.trim(W.val()).length<ws_plugin__s2member_passwordMinLength()){alert('— Oops, you missed something: —\n\nPassword MUST be at least 8 characters. Please try again.');return false}else{if(W.length&&ws_plugin__s2member_passwordStrengthMeter(A.trim(W.val()),A.trim(V.val()),true)<ws_plugin__s2member_passwordMinStrengthScore()){alert('— Oops, you missed something: —\n\nPassword strength MUST be `good` or `strong` (i.e., use numbers, letters, and mixed caSe). Please try again.');return false}else{if(T.length&&!T.val()){alert('— Oops, you missed something: —\n\nSecurity Verification missing. Please try again.');return false}}}}}}w.attr(B),ws_plugin__s2member_animateProcessing(w);return true})}else{if((n=A("form#s2member-pro-paypal-sp-checkout-form")).length===1){var j,F,K,t=true,J,p,f,D,c,E,u,a="div#s2member-pro-paypal-sp-checkout-form-options-section",G="div#s2member-pro-paypal-sp-checkout-form-description-section",H="div#s2member-pro-paypal-sp-checkout-form-coupon-section",P=H+" input#s2member-pro-paypal-sp-checkout-coupon-apply",N="div#s2member-pro-paypal-sp-checkout-form-registration-section",v="div#s2member-pro-paypal-sp-checkout-form-billing-method-section",m=v+' input[name="s2member_pro_paypal_sp_checkout[card_type]"]',I="div#s2member-pro-paypal-sp-checkout-form-billing-address-section",y=A(I+" > div#s2member-pro-paypal-sp-checkout-form-ajax-tax-div"),O="div#s2member-pro-paypal-sp-checkout-form-captcha-section",o="div#s2member-pro-paypal-sp-checkout-form-submission-section",l=o+" input#s2member-pro-paypal-sp-checkout-nonce",d=o+" #s2member-pro-paypal-sp-checkout-submit";var C=A.trim(A("input#s2member-pro-paypal-lang-attr").val());var g='<button type="submit" id="s2member-pro-paypal-sp-checkout-submit" class="s2member-pro-paypal-submit s2member-pro-paypal-sp-checkout-submit btn btn-primary" tabindex="500">Submit Form</button>';var h='<input type="image" src="https://www.paypal.com/'+((C)?C:'en_US')+'/i/btn/btn_xpressCheckout.gif" id="s2member-pro-paypal-sp-checkout-submit" class="s2member-pro-paypal-submit s2member-pro-paypal-sp-checkout-submit" value="Submit Form" tabindex="500" />';ws_plugin__s2member_animateProcessing(A(d),"reset"),A(d).removeAttr("disabled"),A(P).removeAttr("disabled");(j=function(R){if(!A(a+" select#s2member-pro-paypal-sp-checkout-options option").length){A(a).hide();A(G).show()}else{A(a).show();A(G).hide();A(a+" select#s2member-pro-paypal-sp-checkout-options").change(function(){A(l).val("option");n.attr("action",n.attr("action").replace(/#.*$/,"")+"#s2p-form");n.submit()})}})();(F=function(R){if(A(o+" input#s2member-pro-paypal-sp-checkout-coupons-not-required-or-not-possible").length){A(H).hide()}else{A(H).show()}})();(K=function(R){if(A(o+" input#s2member-pro-paypal-sp-checkout-tax-not-required-or-not-possible").length){y.hide(),t=false}})();(J=function(S){if(t&&!(S&&S.interval&&document.activeElement.id==="s2member-pro-paypal-sp-checkout-country")){var R=A(o+" input#s2member-pro-paypal-sp-checkout-attr").val();var V=A.trim(A(I+" input#s2member-pro-paypal-sp-checkout-state").val());var W=A(I+" select#s2member-pro-paypal-sp-checkout-country").val();var U=A.trim(A(I+" input#s2member-pro-paypal-sp-checkout-zip").val());var T=V+"|"+W+"|"+U;if(V&&W&&U&&T&&(!c||c!==T)&&(c=T)){(D)?D.abort():null,clearTimeout(f),f=null;y.html('<div><img src="https://www.datanovia.com/en/wp-content/plugins/s2member/src/images/ajax-loader.gif" alt="Calculating Sales Tax..." /> calculating sales tax...</div>');f=setTimeout(function(){D=A.post('https://www.datanovia.com/en/wp-admin/admin-ajax.php',{action:"ws_plugin__s2member_pro_paypal_ajax_tax",ws_plugin__s2member_pro_paypal_ajax_tax:'ZGVmNTAyMDAzM2ZiZDNhZDFiMTVmZWI3OGJiOGYwYTgyOGI0YmJjYjkxYWUyN2VlNmQzM2QyNmYwMmI4MTAwMGI5Y2E5OWYzZGRlMTU3NGY5NDBiZDU1ZTIzZDRjY2NlZDc0NGQxODYzOTc0Yjk1ODQ2MzcwM2U3NTg0OGM3ZjhhYTIyYjUyODhhZDJlZjRlMDIxMmQ3OTc3ZGM2MmM0MmM2NWE2Mzg0NDE2YzYzZGU1ZGE5YTUwMTNjNGYwZDEwNjBmZGUxNWRiNzc5ZjYwYmRkMTk5NjExYWEwMzg3ZDM2MDQ1YTJhYTQ3MGQ4OGRkOTI3MTMz',"ws_plugin__s2member_pro_paypal_ajax_tax_vars[attr]":R,"ws_plugin__s2member_pro_paypal_ajax_tax_vars[state]":V,"ws_plugin__s2member_pro_paypal_ajax_tax_vars[country]":W,"ws_plugin__s2member_pro_paypal_ajax_tax_vars[zip]":U},function(X){clearTimeout(f),f=null;try{y.html("<div>"+A.sprintf('<strong>Sales Tax%s:</strong> %s<br /><strong>— Total%s:</strong> %s',((X.trial)?' Today':""),((X.tax_per)?"<em>"+X.tax_per+"</em> ( "+X.cur_symbol+""+X.tax+" )":X.cur_symbol+""+X.tax),((X.trial)?' Today':""),X.cur_symbol+""+X.total)+"</div>")}catch(Y){}},"json")},((S&&S.keyCode)?1000:100))}else{if(!V||!W||!U||!T){y.html(""),c=null}}}})();p=function(R){setTimeout(function(){J(R)},10)};A(I+" input#s2member-pro-paypal-sp-checkout-state").bind("keyup blur",J).bind("cut paste",p);A(I+" input#s2member-pro-paypal-sp-checkout-zip").bind("keyup blur",J).bind("cut paste",p);A(I+" select#s2member-pro-paypal-sp-checkout-country").bind("change",J);setInterval(function(){J({interval:true})},1000);(E=function(R){if(S2MEMBER_CURRENT_USER_IS_LOGGED_IN){A(N+" input#s2member-pro-paypal-sp-checkout-first-name").each(function(){var S=A(this),T=S.val();(!T)?S.val(S2MEMBER_CURRENT_USER_FIRST_NAME):null});A(N+" input#s2member-pro-paypal-sp-checkout-last-name").each(function(){var S=A(this),T=S.val();(!T)?S.val(S2MEMBER_CURRENT_USER_LAST_NAME):null});A(N+" input#s2member-pro-paypal-sp-checkout-email").each(function(){var S=A(this),T=S.val();(!T)?S.val(S2MEMBER_CURRENT_USER_EMAIL):null})}})();(u=function(R){if(A(o+" input#s2member-pro-paypal-sp-checkout-payment-not-required-or-not-possible").length){A(m).val(["Free"])}var S=A(m+":checked").val();if(A.inArray(S,["Free"])!==-1){A(v).hide(),A(I).hide();A(v+" > div.s2member-pro-paypal-sp-checkout-form-div").hide();A(v+" > div.s2member-pro-paypal-sp-checkout-form-div :input").attr(b);A(I+" > div.s2member-pro-paypal-sp-checkout-form-div").hide();A(I+" > div.s2member-pro-paypal-sp-checkout-form-div :input").attr(b);(!t)?y.hide():null;A(o+" #s2member-pro-paypal-sp-checkout-submit").replaceWith(g);(R)?A(o+" #s2member-pro-paypal-sp-checkout-submit").focus():null}else{if(A.inArray(S,["Visa","MasterCard","Amex","Discover"])!==-1){A(v).show(),A(I).show();A(v+" > div.s2member-pro-paypal-sp-checkout-form-div").show();A(v+" > div.s2member-pro-paypal-sp-checkout-form-div :input").attr(x);A(v+" > div#s2member-pro-paypal-sp-checkout-form-card-start-date-issue-number-div").hide();A(v+" > div#s2member-pro-paypal-sp-checkout-form-card-start-date-issue-number-div :input").attr(b);A(I+" > div.s2member-pro-paypal-sp-checkout-form-div").show();A(I+" > div.s2member-pro-paypal-sp-checkout-form-div :input").attr(x);(!t)?y.hide():null;A(o+" #s2member-pro-paypal-sp-checkout-submit").replaceWith(g);(R)?A(v+" input#s2member-pro-paypal-sp-checkout-card-number").focus():null}else{if(A.inArray(S,["Maestro","Solo"])!==-1){A(v).show(),A(I).show();A(v+" > div.s2member-pro-paypal-sp-checkout-form-div").show();A(v+" > div.s2member-pro-paypal-sp-checkout-form-div :input").attr(x);A(I+" > div.s2member-pro-paypal-sp-checkout-form-div").show();A(I+" > div.s2member-pro-paypal-sp-checkout-form-div :input").attr(x);(!t)?y.hide():null;A(o+" #s2member-pro-paypal-sp-checkout-submit").replaceWith(g);(R)?A(v+" input#s2member-pro-paypal-sp-checkout-card-number").focus():null}else{if((!S||S==="PayPal")&&t){if(A(v).attr("data-paypal-only")){A(v).hide()}else{A(v).show()}A(I).show();A(v+" > div.s2member-pro-paypal-sp-checkout-form-div").show();A(v+" > div.s2member-pro-paypal-sp-checkout-form-div :input").attr(x);A(v+" > div#s2member-pro-paypal-sp-checkout-form-card-number-div").hide();A(v+" > div#s2member-pro-paypal-sp-checkout-form-card-number-div :input").attr(b);A(v+" > div#s2member-pro-paypal-sp-checkout-form-card-expiration-div").hide();A(v+" > div#s2member-pro-paypal-sp-checkout-form-card-expiration-div :input").attr(b);A(v+" > div#s2member-pro-paypal-sp-checkout-form-card-verification-div").hide();A(v+" > div#s2member-pro-paypal-sp-checkout-form-card-verification-div :input").attr(b);A(v+" > div#s2member-pro-paypal-sp-checkout-form-card-start-date-issue-number-div").hide();A(v+" > div#s2member-pro-paypal-sp-checkout-form-card-start-date-issue-number-div :input").attr(b);A(I+" > div.s2member-pro-paypal-sp-checkout-form-div").show();A(I+" > div.s2member-pro-paypal-sp-checkout-form-div :input").attr(x);A(I+" > div#s2member-pro-paypal-sp-checkout-form-street-div").hide();A(I+" > div#s2member-pro-paypal-sp-checkout-form-street-div :input").attr(b);A(I+" > div#s2member-pro-paypal-sp-checkout-form-city-div").hide();A(I+" > div#s2member-pro-paypal-sp-checkout-form-city-div :input").attr(b);A(o+" #s2member-pro-paypal-sp-checkout-submit").replaceWith(h);(R)?A(I+" input#s2member-pro-paypal-sp-checkout-state").focus():null}else{if(!S||S==="PayPal"){if(A(v).attr("data-paypal-only")){A(v).hide()}else{A(v).show()}A(I).hide();A(v+" > div.s2member-pro-paypal-sp-checkout-form-div").hide();A(v+" > div.s2member-pro-paypal-sp-checkout-form-div :input").attr(b);A(v+" > div#s2member-pro-paypal-sp-checkout-form-card-type-div").show();A(v+" > div#s2member-pro-paypal-sp-checkout-form-card-type-div :input").attr(x);A(I+" > div.s2member-pro-paypal-sp-checkout-form-div").hide();A(I+" > div.s2member-pro-paypal-sp-checkout-form-div :input").attr(b);A(o+" #s2member-pro-paypal-sp-checkout-submit").replaceWith(h);(R)?A(o+" #s2member-pro-paypal-sp-checkout-submit").focus():null}}}}}K()})();A(m).click(u).change(u);A(P).click(function(){A(l).val("apply-coupon"),n.submit()});n.submit(function(){if(A.inArray(A(l).val(),["option","apply-coupon"])===-1){var U=this,S="",R="",V="";var T=A(O+" input#recaptcha_response_field, "+O+" #g-recaptcha-response");if(!A(m+":checked").val()){A(m).val(["PayPal"])}A(":input",U).each(function(){var W=A.trim(A(this).attr("id")).replace(/---[0-9]+$/g,"");if(W&&(S=A.trim(A('label[for="'+W.replace(/-(month|year)/,"")+'"]',U).first().children("span").first().text().replace(/[\r\n\t]+/g," ")))){if(R=ws_plugin__s2member_validationErrors(S,this,U)){V+=R+"\n\n"}}});if(V=A.trim(V)){alert('— Oops, you missed something: —\n\n'+V);return false}else{if(T.length&&!T.val()){alert('— Oops, you missed something: —\n\nSecurity Verification missing. Please try again.');return false}}}A(d).attr(B),ws_plugin__s2member_animateProcessing(A(d)),A(P).attr(B);return true})}else{if((q=A("form#s2member-pro-paypal-checkout-form")).length===1){var j,F,K,t=true,J,p,f,D,c,s,u,E,a="div#s2member-pro-paypal-checkout-form-options-section",G="div#s2member-pro-paypal-checkout-form-description-section",H="div#s2member-pro-paypal-checkout-form-coupon-section",P=H+" input#s2member-pro-paypal-checkout-coupon-apply",N="div#s2member-pro-paypal-checkout-form-registration-section",Q="div#s2member-pro-paypal-checkout-form-custom-fields-section",v="div#s2member-pro-paypal-checkout-form-billing-method-section",m=v+' input[name="s2member_pro_paypal_checkout[card_type]"]',I="div#s2member-pro-paypal-checkout-form-billing-address-section",y=A(I+" > div#s2member-pro-paypal-checkout-form-ajax-tax-div"),O="div#s2member-pro-paypal-checkout-form-captcha-section",o="div#s2member-pro-paypal-checkout-form-submission-section",l=o+" input#s2member-pro-paypal-checkout-nonce",d=o+" #s2member-pro-paypal-checkout-submit";var C=A.trim(A("input#s2member-pro-paypal-lang-attr").val());var g='<button type="submit" id="s2member-pro-paypal-checkout-submit" class="s2member-pro-paypal-submit s2member-pro-paypal-checkout-submit btn btn-primary" tabindex="600">Submit Form</button>';var h='<input type="image" src="https://www.paypal.com/'+((C)?C:'en_US')+'/i/btn/btn_xpressCheckout.gif" id="s2member-pro-paypal-checkout-submit" class="s2member-pro-paypal-submit s2member-pro-paypal-checkout-submit" value="Submit Form" tabindex="600" />';ws_plugin__s2member_animateProcessing(A(d),"reset"),A(d).removeAttr("disabled"),A(P).removeAttr("disabled");(j=function(R){if(!A(a+" select#s2member-pro-paypal-checkout-options option").length){A(a).hide();A(G).show()}else{A(a).show();A(G).hide();A(a+" select#s2member-pro-paypal-checkout-options").change(function(){A(l).val("option");q.attr("action",q.attr("action").replace(/#.*$/,"")+"#s2p-form");q.submit()})}})();(F=function(R){if(A(o+" input#s2member-pro-paypal-checkout-coupons-not-required-or-not-possible").length){A(H).hide()}else{A(H).show()}})();(K=function(R){if(A(o+" input#s2member-pro-paypal-checkout-tax-not-required-or-not-possible").length){y.hide(),t=false}})();(J=function(S){if(t&&!(S&&S.interval&&document.activeElement.id==="s2member-pro-paypal-checkout-country")){var R=A(o+" input#s2member-pro-paypal-checkout-attr").val();var V=A.trim(A(I+" input#s2member-pro-paypal-checkout-state").val());var W=A(I+" select#s2member-pro-paypal-checkout-country").val();var U=A.trim(A(I+" input#s2member-pro-paypal-checkout-zip").val());var T=V+"|"+W+"|"+U;if(V&&W&&U&&T&&(!c||c!==T)&&(c=T)){(D)?D.abort():null,clearTimeout(f),f=null;y.html('<div><img src="https://www.datanovia.com/en/wp-content/plugins/s2member/src/images/ajax-loader.gif" alt="Calculating Sales Tax..." /> calculating sales tax...</div>');f=setTimeout(function(){D=A.post('https://www.datanovia.com/en/wp-admin/admin-ajax.php',{action:"ws_plugin__s2member_pro_paypal_ajax_tax",ws_plugin__s2member_pro_paypal_ajax_tax:'ZGVmNTAyMDBjMTVjZmJmYWJiZDBlZTg4NDZjM2FlZmI5ZDhjYmNlOTJmMTk0ZWZhYTc0OWJlYWNhMzFmY2ZlYzI4NjJhYjBmY2Q3MTZlMjQ5ZGYxNDdiOTUzODUxZGU3MTc5OWM3M2MyNjU0ZGVkZmJiODdkZjAyNzNhYzNjNWZlZGNjZDU0Mzg2M2QwNzA3MGE4NDhhZGI2MDE0ODY5MmE5OTA4ODNmNjk4ODE2Y2MyYWU5ZDlmYjI5OGExMWJlMGUzZTNjMWJmMDBlZTEwOTY2OWU2YTRkZjg4MzMwNTk0YjgyZjZmNTE1NDFkYTllMDA2NjNl',"ws_plugin__s2member_pro_paypal_ajax_tax_vars[attr]":R,"ws_plugin__s2member_pro_paypal_ajax_tax_vars[state]":V,"ws_plugin__s2member_pro_paypal_ajax_tax_vars[country]":W,"ws_plugin__s2member_pro_paypal_ajax_tax_vars[zip]":U},function(X,Z){clearTimeout(f),f=null;try{y.html("<div>"+A.sprintf('<strong>Sales Tax%s:</strong> %s<br /><strong>— Total%s:</strong> %s',((X.trial)?' Today':""),((X.tax_per)?"<em>"+X.tax_per+"</em> ( "+X.cur_symbol+""+X.tax+" )":X.cur_symbol+""+X.tax),((X.trial)?' Today':""),X.cur_symbol+""+X.total)+"</div>")}catch(Y){}},"json")},((S&&S.keyCode)?1000:100))}else{if(!V||!W||!U||!T){y.html(""),c=null}}}})();p=function(R){setTimeout(function(){J(R)},10)};A(I+" input#s2member-pro-paypal-checkout-state").bind("keyup blur",J).bind("cut paste",p);A(I+" input#s2member-pro-paypal-checkout-zip").bind("keyup blur",J).bind("cut paste",p);A(I+" select#s2member-pro-paypal-checkout-country").bind("change",J);setInterval(function(){J({interval:true})},1000);(s=function(R){if(A(o+" input#s2member-pro-paypal-checkout-password-not-required-or-not-possible").length){A(N+" > div#s2member-pro-paypal-checkout-form-password-div").hide();A(N+" > div#s2member-pro-paypal-checkout-form-password-div :input").attr(i)}})();(E=function(R){if(S2MEMBER_CURRENT_USER_IS_LOGGED_IN){A(N+" input#s2member-pro-paypal-checkout-first-name").each(function(){var S=A(this),T=S.val();(!T)?S.val(S2MEMBER_CURRENT_USER_FIRST_NAME):null});A(N+" input#s2member-pro-paypal-checkout-last-name").each(function(){var S=A(this),T=S.val();(!T)?S.val(S2MEMBER_CURRENT_USER_LAST_NAME):null});A(N+" input#s2member-pro-paypal-checkout-email").val(S2MEMBER_CURRENT_USER_EMAIL).attr(i);A(N+" input#s2member-pro-paypal-checkout-username").val(S2MEMBER_CURRENT_USER_LOGIN).attr(i);A(N+" > div#s2member-pro-paypal-checkout-form-password-div").hide();A(N+" > div#s2member-pro-paypal-checkout-form-password-div :input").attr(i);if(A.trim(A(N+" > div#s2member-pro-paypal-checkout-form-registration-section-title").html())==='Create Profile'){A(N+" > div#s2member-pro-paypal-checkout-form-registration-section-title").html('Your Profile')}A(Q).hide(),A(Q+" :input").attr(i)}})();(u=function(R){if(A(o+" input#s2member-pro-paypal-checkout-payment-not-required-or-not-possible").length){A(m).val(["Free"])}var S=A(m+":checked").val();if(A.inArray(S,["Free"])!==-1){A(v).hide(),A(I).hide();A(v+" > div.s2member-pro-paypal-checkout-form-div").hide();A(v+" > div.s2member-pro-paypal-checkout-form-div :input").attr(b);A(I+" > div.s2member-pro-paypal-checkout-form-div").hide();A(I+" > div.s2member-pro-paypal-checkout-form-div :input").attr(b);(!t)?y.hide():null;A(o+" #s2member-pro-paypal-checkout-submit").replaceWith(g);(R)?A(o+" #s2member-pro-paypal-checkout-submit").focus():null}else{if(A.inArray(S,["Visa","MasterCard","Amex","Discover"])!==-1){A(v).show(),A(I).show();A(v+" > div.s2member-pro-paypal-checkout-form-div").show();A(v+" > div.s2member-pro-paypal-checkout-form-div :input").attr(x);A(v+" > div#s2member-pro-paypal-checkout-form-card-start-date-issue-number-div").hide();A(v+" > div#s2member-pro-paypal-checkout-form-card-start-date-issue-number-div :input").attr(b);A(I+" > div.s2member-pro-paypal-checkout-form-div").show();A(I+" > div.s2member-pro-paypal-checkout-form-div :input").attr(x);(!t)?y.hide():null;A(o+" #s2member-pro-paypal-checkout-submit").replaceWith(g);(R)?A(v+" input#s2member-pro-paypal-checkout-card-number").focus():null}else{if(A.inArray(S,["Maestro","Solo"])!==-1){A(v).show(),A(I).show();A(v+" > div.s2member-pro-paypal-checkout-form-div").show();A(v+" > div.s2member-pro-paypal-checkout-form-div :input").attr(x);A(I+" > div.s2member-pro-paypal-checkout-form-div").show();A(I+" > div.s2member-pro-paypal-checkout-form-div :input").attr(x);(!t)?y.hide():null;A(o+" #s2member-pro-paypal-checkout-submit").replaceWith(g);(R)?A(v+" input#s2member-pro-paypal-checkout-card-number").focus():null}else{if((!S||S==="PayPal")&&t){if(A(v).attr("data-paypal-only")){A(v).hide()}else{A(v).show()}A(I).show();A(v+" > div.s2member-pro-paypal-checkout-form-div").show();A(v+" > div.s2member-pro-paypal-checkout-form-div :input").attr(x);A(v+" > div#s2member-pro-paypal-checkout-form-card-number-div").hide();A(v+" > div#s2member-pro-paypal-checkout-form-card-number-div :input").attr(b);A(v+" > div#s2member-pro-paypal-checkout-form-card-expiration-div").hide();A(v+" > div#s2member-pro-paypal-checkout-form-card-expiration-div :input").attr(b);A(v+" > div#s2member-pro-paypal-checkout-form-card-verification-div").hide();A(v+" > div#s2member-pro-paypal-checkout-form-card-verification-div :input").attr(b);A(v+" > div#s2member-pro-paypal-checkout-form-card-start-date-issue-number-div").hide();A(v+" > div#s2member-pro-paypal-checkout-form-card-start-date-issue-number-div :input").attr(b);A(I+" > div.s2member-pro-paypal-checkout-form-div").show();A(I+" > div.s2member-pro-paypal-checkout-form-div :input").attr(x);A(I+" > div#s2member-pro-paypal-checkout-form-street-div").hide();A(I+" > div#s2member-pro-paypal-checkout-form-street-div :input").attr(b);A(I+" > div#s2member-pro-paypal-checkout-form-city-div").hide();A(I+" > div#s2member-pro-paypal-checkout-form-city-div :input").attr(b);A(o+" #s2member-pro-paypal-checkout-submit").replaceWith(h);(R)?A(I+" input#s2member-pro-paypal-checkout-state").focus():null}else{if(!S||S==="PayPal"){if(A(v).attr("data-paypal-only")){A(v).hide()}else{A(v).show()}A(I).hide();A(v+" > div.s2member-pro-paypal-checkout-form-div").hide();A(v+" > div.s2member-pro-paypal-checkout-form-div :input").attr(b);A(v+" > div#s2member-pro-paypal-checkout-form-card-type-div").show();A(v+" > div#s2member-pro-paypal-checkout-form-card-type-div :input").attr(x);A(I+" > div.s2member-pro-paypal-checkout-form-div").hide();A(I+" > div.s2member-pro-paypal-checkout-form-div :input").attr(b);A(o+" #s2member-pro-paypal-checkout-submit").replaceWith(h);(R)?A(o+" #s2member-pro-paypal-checkout-submit").focus():null}}}}}})();A(m).click(u).change(u);A(P).click(function(){A(l).val("apply-coupon"),q.submit()});A(N+" > div#s2member-pro-paypal-checkout-form-password-div :input").on("keyup initialize.s2",function(){ws_plugin__s2member_passwordStrength(A(N+" input#s2member-pro-paypal-checkout-username"),A(N+" input#s2member-pro-paypal-checkout-password1"),A(N+" input#s2member-pro-paypal-checkout-password2"),A(N+" div#s2member-pro-paypal-checkout-form-password-strength"))}).trigger("initialize.s2");q.submit(function(){if(A.inArray(A(l).val(),["option","apply-coupon"])===-1){var U=this,S="",R="",X="";var T=A(O+" input#recaptcha_response_field, "+O+" #g-recaptcha-response");var W=A(N+' input#s2member-pro-paypal-checkout-password1[aria-required="true"]');var V=A(N+" input#s2member-pro-paypal-checkout-password2");if(!A(m+":checked").val()){A(m).val(["PayPal"])}A(":input",U).each(function(){var Y=A.trim(A(this).attr("id")).replace(/---[0-9]+$/g,"");if(Y&&(S=A.trim(A('label[for="'+Y.replace(/-(month|year)/,"")+'"]',U).first().children("span").first().text().replace(/[\r\n\t]+/g," ")))){if(R=ws_plugin__s2member_validationErrors(S,this,U)){X+=R+"\n\n"}}});if(X=A.trim(X)){alert('— Oops, you missed something: —\n\n'+X);return false}else{if(W.length&&A.trim(W.val())!==A.trim(V.val())){alert('— Oops, you missed something: —\n\nPasswords do not match up. Please try again.');return false}else{if(W.length&&A.trim(W.val()).length<ws_plugin__s2member_passwordMinLength()){alert('— Oops, you missed something: —\n\nPassword MUST be at least 8 characters. Please try again.');return false}else{if(W.length&&ws_plugin__s2member_passwordStrengthMeter(A.trim(W.val()),A.trim(V.val()),true)<ws_plugin__s2member_passwordMinStrengthScore()){alert('— Oops, you missed something: —\n\nPassword strength MUST be `good` or `strong` (i.e., use numbers, letters, and mixed caSe). Please try again.');return false}else{if(T.length&&!T.val()){alert('— Oops, you missed something: —\n\nSecurity Verification missing. Please try again.');return false}}}}}}A(d).attr(B),ws_plugin__s2member_animateProcessing(A(d)),A(P).attr(B);return true})}}}}}(L=function(){A("div#s2member-pro-paypal-form-response").each(function(){var R=A(this).offset();window.scrollTo(0,R.top-100)})})()});
var S2MEMBER_PRO_STRIPE_GATEWAY = true;
/**
 * Core JavaScript routines for Stripe.
 *
 * Copyright: © 2009-2011
 * {@link http://websharks-inc.com/ WebSharks, Inc.}
 * (coded in the USA)
 *
 * This WordPress plugin (s2Member Pro) is comprised of two parts:
 *
 * o (1) Its PHP code is licensed under the GPL license, as is WordPress.
 *   You should have received a copy of the GNU General Public License,
 *   along with this software. In the main directory, see: /licensing/
 *   If not, see: {@link http://www.gnu.org/licenses/}.
 *
 * o (2) All other parts of (s2Member Pro); including, but not limited to:
 *   the CSS code, some JavaScript code, images, and design;
 *   are licensed according to the license purchased.
 *   See: {@link http://s2member.com/prices/}
 *
 * Unless you have our prior written consent, you must NOT directly or indirectly license,
 * sub-license, sell, resell, or provide for free; part (2) of the s2Member Pro Add-on;
 * or make an offer to do any of these things. All of these things are strictly
 * prohibited with part (2) of the s2Member Pro Add-on.
 *
 * Your purchase of s2Member Pro includes free lifetime upgrades via s2Member.com
 * (i.e., new features, bug fixes, updates, improvements); along with full access
 * to our video tutorial library: {@link http://s2member.com/videos/}
 *
 * @package s2Member\Stripe
 * @since 140617
 */
jQuery(document).ready( // DOM ready.
	function($) // Depends on Stripe lib.
	{
		// Load this only if we have a Stripe pro-form on the page.
		if ($('form.s2member-pro-stripe-form').length > 0)
		{
			// Setup the pro-forms only after we managed to load stripe's JS.
			$.ajax({cache: true, dataType: 'script', url: 'https://js.stripe.com/v3/'});
			var stripeCheck = function() {
				if(window.Stripe) // Stripe available?
					clearInterval(stripeCheckInterval),
					setupProForms();
			},
			stripeCheckInterval = setInterval(stripeCheck, 100);

			var setupProForms = function()
			{
				/*
				Initializations.
				*/
				var preloadAjaxLoader, // Loading image.
					$clForm, $upForm, $rgForm, $spForm, $coForm,
					ariaTrue = {'aria-required': 'true'}, ariaFalse = {'aria-required': 'false'},
					ariaFalseDis = {'aria-required': 'false', 'disabled': 'disabled'},
					disabled = {'disabled': 'disabled'},

					taxMayApply = true, calculateTax, cTaxDelay, cTaxTimeout, cTaxReq, cTaxLocation, ajaxTaxDiv,
					optionsSection, optionsSelect, descSection, couponSection, couponApplyButton, registrationSection, customFieldsSection,
					billingMethodSection, handleBillingMethod, sourceTokenButton, sourceTokenSummary, sourceTokenInput, sourceTokenSummaryInput, billingAddressSection, captchaSection,
					submissionSection, submissionButton, submissionNonceVerification;

				preloadAjaxLoader = new Image(), preloadAjaxLoader.src = 'https://www.datanovia.com/en/wp-content/plugins/s2member/src/images/ajax-loader.gif';

				/*
				Check for more than a single form on this page.
				*/
				if($('form.s2member-pro-stripe-cancellation-form').length > 1
					|| $('form.s2member-pro-stripe-registration-form').length > 1 || $('form.s2member-pro-stripe-update-form').length > 1
					|| $('form.s2member-pro-stripe-sp-checkout-form').length > 1 || $('form.s2member-pro-stripe-checkout-form').length > 1)
				{
					return alert('Detected more than one s2Member Pro-Form.\n\nPlease use only ONE s2Member Pro-Form Shortcode on each Post/Page.' +
											' Attempting to serve more than one Pro-Form on each Post/Page (even w/ DHTML) may result in unexpected/broken functionality.');
				}
				/*
				Cancellation form handler.
				*/
				if(($clForm = $('form#s2member-pro-stripe-cancellation-form')).length === 1)
				{
					captchaSection = 'div#s2member-pro-stripe-cancellation-form-captcha-section',
						submissionSection = 'div#s2member-pro-stripe-cancellation-form-submission-section',
						submissionButton = submissionSection + ' button#s2member-pro-stripe-cancellation-submit';

					$(submissionButton).removeAttr('disabled'),
						ws_plugin__s2member_animateProcessing($(submissionButton), 'reset');

					$clForm.on('submit', function(/* Form validation. */)
					{
						var context = this, label = '', error = '', errors = '',
							$recaptchaResponse = $(captchaSection + ' input#recaptcha_response_field, '+captchaSection+' #g-recaptcha-response');

						$(':input', context)
							.each(function(/* Go through them all together. */)
										{
											var id = $.trim($(this).attr('id')).replace(/---[0-9]+$/g, ''/* Remove numeric suffixes. */);

											if(id && (label = $.trim($('label[for="' + id + '"]', context).first().children('span').first().text().replace(/[\r\n\t]+/g, ' '))))
											{
												if(error = ws_plugin__s2member_validationErrors(label, this, context))
													errors += error + '\n\n'/* Collect errors. */;
											}
										});
						if((errors = $.trim(errors)))
						{
							alert('— Oops, you missed something: —' + '\n\n' + errors);
							return false; // Error; cannot continue in this scenario.
						}
						else if($recaptchaResponse.length && !$recaptchaResponse.val())
						{
							alert('— Oops, you missed something: —' + '\n\n' + 'Security Verification missing. Please try again.');
							return false; // Error; cannot continue in this scenario.
						}
						$(submissionButton).attr(disabled),
							ws_plugin__s2member_animateProcessing($(submissionButton));
						return true; // Allow submission.
					});
				}
				/*
				Registration form handler.
				*/
				else if(($rgForm = $('form#s2member-pro-stripe-registration-form')).length === 1)
				{
					optionsSection = 'div#s2member-pro-stripe-registration-form-options-section',
						optionsSelect = optionsSection + ' select#s2member-pro-stripe-registration-options',

						descSection = 'div#s2member-pro-stripe-registration-form-description-section',

						registrationSection = 'div#s2member-pro-stripe-registration-form-registration-section',
						captchaSection = 'div#s2member-pro-stripe-registration-form-captcha-section',
						submissionSection = 'div#s2member-pro-stripe-registration-form-submission-section',
						submissionButton = submissionSection + ' button#s2member-pro-stripe-registration-submit',
						submissionNonceVerification = submissionSection + ' input#s2member-pro-stripe-registration-nonce';

					$(submissionButton).removeAttr('disabled'),
						ws_plugin__s2member_animateProcessing($(submissionButton), 'reset');

					if(!$(optionsSelect + ' option').length)
						$(optionsSection).hide(), $(descSection).show();

					else $(optionsSection).show(), $(descSection).hide(),
						$(optionsSelect).on('change', function(/* Handle checkout option changes. */)
						{
							$(submissionNonceVerification).val('option'),
								$rgForm.attr('action', $rgForm.attr('action').replace(/#.*$/, '') + '#s2p-form'),
								$rgForm.submit(); // Submit form with a new checkout option.
						});
					if($(submissionSection + ' input#s2member-pro-stripe-registration-names-not-required-or-not-possible').length)
					{
						$(registrationSection + ' > div#s2member-pro-stripe-registration-form-first-name-div').hide(),
							$(registrationSection + ' > div#s2member-pro-stripe-registration-form-first-name-div :input').attr(ariaFalseDis);

						$(registrationSection + ' > div#s2member-pro-stripe-registration-form-last-name-div').hide(),
							$(registrationSection + ' > div#s2member-pro-stripe-registration-form-last-name-div :input').attr(ariaFalseDis);
					}
					if($(submissionSection + ' input#s2member-pro-stripe-registration-password-not-required-or-not-possible').length)
					{
						$(registrationSection + ' > div#s2member-pro-stripe-registration-form-password-div').hide(),
							$(registrationSection + ' > div#s2member-pro-stripe-registration-form-password-div :input').attr(ariaFalseDis);
					}
					$(registrationSection + ' > div#s2member-pro-stripe-registration-form-password-div :input').on('keyup initialize.s2', function()
					{
						ws_plugin__s2member_passwordStrength(
							$(registrationSection + ' input#s2member-pro-stripe-registration-username'),
							$(registrationSection + ' input#s2member-pro-stripe-registration-password1'),
							$(registrationSection + ' input#s2member-pro-stripe-registration-password2'),
							$(registrationSection + ' div#s2member-pro-stripe-registration-form-password-strength')
						);
					}).trigger('initialize.s2');
					$rgForm.on('submit', function(/* Form validation. */)
					{
						if($.inArray($(submissionNonceVerification).val(), ['option']) === -1)
						{
							var context = this, label = '', error = '', errors = '',
								$recaptchaResponse = $(captchaSection + ' input#recaptcha_response_field, '+captchaSection+' #g-recaptcha-response'),
								$password1 = $(registrationSection + ' input#s2member-pro-stripe-registration-password1[aria-required="true"]'),
								$password2 = $(registrationSection + ' input#s2member-pro-stripe-registration-password2');

							$(':input', context)
								.each(function(/* Go through them all together. */)
											{
												var id = $.trim($(this).attr('id')).replace(/---[0-9]+$/g, ''/* Remove numeric suffixes. */);

												if(id && (label = $.trim($('label[for="' + id + '"]', context).first().children('span').first().text().replace(/[\r\n\t]+/g, ' '))))
												{
													if(error = ws_plugin__s2member_validationErrors(label, this, context))
														errors += error + '\n\n'/* Collect errors. */;
												}
											});
							if((errors = $.trim(errors)))
							{
								alert('— Oops, you missed something: —' + '\n\n' + errors);
								return false; // Error; cannot continue in this scenario.
							}
							else if($password1.length && $.trim($password1.val()) !== $.trim($password2.val()))
							{
								alert('— Oops, you missed something: —' + '\n\n' + 'Passwords do not match up. Please try again.');
								return false; // Error; cannot continue in this scenario.
							}
							else if($password1.length && $.trim($password1.val()).length < ws_plugin__s2member_passwordMinLength())
							{
								alert('— Oops, you missed something: —' + '\n\n' + 'Password MUST be at least 8 characters. Please try again.');
								return false;
							}
							else if($password1.length && ws_plugin__s2member_passwordStrengthMeter($.trim($password1.val()), $.trim($password2.val()), true) < ws_plugin__s2member_passwordMinStrengthScore())
							{
								alert('— Oops, you missed something: —' + '\n\n' + 'Password strength MUST be `good` or `strong` (i.e., use numbers, letters, and mixed caSe). Please try again.');
								return false;
							}
							else if($recaptchaResponse.length && !$recaptchaResponse.val())
							{
								alert('— Oops, you missed something: —' + '\n\n' + 'Security Verification missing. Please try again.');
								return false; // Error; cannot continue in this scenario.
							}
							// $(optionsSelect).attr(disabled); // Not an option selection.
							// Bug fix. Don't disable, because that prevents it from being submitted.
						}
						$(submissionButton).attr(disabled),
							ws_plugin__s2member_animateProcessing($(submissionButton));
						return true; // Allow submission.
					});
				}
				/*
				Update form handler.
				*/
				else if(($upForm = $('form#s2member-pro-stripe-update-form')).length === 1)
				{
					billingMethodSection = 'div#s2member-pro-stripe-update-form-billing-method-section',
						sourceTokenButton = billingMethodSection + ' button#s2member-pro-stripe-update-form-source-token-button',
						sourceTokenSummary = billingMethodSection + ' div#s2member-pro-stripe-update-form-source-token-summary',

						billingAddressSection = 'div#s2member-pro-stripe-update-form-billing-address-section',

						captchaSection = 'div#s2member-pro-stripe-update-form-captcha-section',

						submissionSection = 'div#s2member-pro-stripe-update-form-submission-section',
						sourceTokenInput = submissionSection + ' input[name="' + ws_plugin__s2member_escjQAttr('s2member_pro_stripe_update[source_token]') + '"]',
						sourceTokenSummaryInput = submissionSection + ' input[name="' + ws_plugin__s2member_escjQAttr('s2member_pro_stripe_update[source_token_summary]') + '"]',
						submissionButton = submissionSection + ' button#s2member-pro-stripe-update-submit';

					$(submissionButton).removeAttr('disabled'),
						ws_plugin__s2member_animateProcessing($(submissionButton), 'reset');

					handleBillingMethod = function(eventTrigger /* eventTrigger is passed by jQuery for DOM events. */)
					{
						var sourceToken = $(sourceTokenInput).val(/* Source token from Stripe. */);

						if(sourceToken/* They have now supplied a source token? */)
						{
							$(billingMethodSection).show(), // Show billing method section.
								$(billingMethodSection + ' > div.s2member-pro-stripe-update-form-div').show(),
								$(billingMethodSection + ' > div.s2member-pro-stripe-update-form-div :input').attr(ariaTrue);

							if(taxMayApply/* If tax may apply, we need to collect a tax location. */)
							{
								$(billingAddressSection).show(), // Show billing address section.
									$(billingAddressSection + ' > div.s2member-pro-stripe-update-form-div').show(),
									$(billingAddressSection + ' > div.s2member-pro-stripe-update-form-div :input').attr(ariaTrue);
							}
							else // There is no reason to collect tax information in this case.
							{
								$(billingAddressSection).hide(), // Hide billing address section.
									$(billingAddressSection + ' > div.s2member-pro-stripe-update-form-div').hide(),
									$(billingAddressSection + ' > div.s2member-pro-stripe-update-form-div :input').attr(ariaFalse);
							}
							if(eventTrigger) $(submissionSection + ' button#s2member-pro-stripe-update-submit').focus();
						}
						else if(!sourceToken/* Else there is no Billing Method supplied. */)
						{
							$(billingMethodSection).show(), // Show billing method section.
								$(billingMethodSection + ' > div.s2member-pro-stripe-update-form-div').show(),
								$(billingMethodSection + ' > div.s2member-pro-stripe-update-form-div :input').attr(ariaTrue);

							$(billingAddressSection).hide(), // Hide billing address section.
								$(billingAddressSection + ' > div.s2member-pro-stripe-update-form-div').hide(),
								$(billingAddressSection + ' > div.s2member-pro-stripe-update-form-div :input').attr(ariaFalse);
						}
					};
					handleBillingMethod(); // Handle billing method immediately to deal with fields already filled in.

					$(sourceTokenButton).on('click', function() // Stripe integration.
					{
						var validateZipCode = $(submissionSection + ' input#s2member-pro-stripe-update-should-validate-zipcode').val() == '1',
							collectBillingAddress = $(submissionSection + ' input#s2member-pro-stripe-update-should-collect-billing-address').val() == '1',
							collectShippingAddress = $(submissionSection + ' input#s2member-pro-stripe-update-should-collect-shipping-address').val() == '1',
							stripeImage = '';

						var getSourceToken = StripeCheckout.configure
						({
							bitcoin: false, // Accept Bitcoin as a funding source in this instance?

							image          : stripeImage ? stripeImage : undefined,
							locale         : 'auto', // Based on visitor's country.

							key            : 'pk_live_ohTSIAosxLpgmwjwCPs2JefP',
							allowRememberMe: '1' == '1',
							panelLabel     : 'Add',
							zipCode        : validateZipCode, billingAddress : collectBillingAddress, shippingAddress: collectShippingAddress,
							email          : typeof S2MEMBER_CURRENT_USER_EMAIL === 'string' ? S2MEMBER_CURRENT_USER_EMAIL : '',

							token: function(token) // Callback handler.
							{
								$(sourceTokenInput).val(token.id), $(sourceTokenSummaryInput).val(buildSourceTokenTextSummary(token)),
									$(sourceTokenSummary).html(ws_plugin__s2member_escHtml(buildSourceTokenTextSummary(token))),
									handleBillingMethod(); // Adjust billing methods fields now also.
							}
						});
						getSourceToken.open(); // Open Stripe overlay.
					});
					$upForm.on('submit', function(/* Form validation. */)
					{
						var context = this, label = '', error = '', errors = '',
							$recaptchaResponse = $(captchaSection + ' input#recaptcha_response_field, '+captchaSection+' #g-recaptcha-response');

						//!!! if(!$(sourceTokenInput).val())
						// {
						// 	alert('No Billing Method; please try again.');
						// 	return false; // Error; cannot continue in this scenario.
						// }
						$(':input', context)
							.each(function(/* Go through them all together. */)
										{
											var id = $.trim($(this).attr('id')).replace(/---[0-9]+$/g, ''/* Remove numeric suffixes. */);

											if(id && (label = $.trim($('label[for="' + id.replace(/-(month|year)/, '') + '"]', context).first().children('span').first().text().replace(/[\r\n\t]+/g, ' '))))
											{
												if(error = ws_plugin__s2member_validationErrors(label, this, context))
													errors += error + '\n\n'/* Collect errors. */;
											}
										});
						if((errors = $.trim(errors)))
						{
							alert('— Oops, you missed something: —' + '\n\n' + errors);
							return false; // Error; cannot continue in this scenario.
						}
						else if($recaptchaResponse.length && !$recaptchaResponse.val())
						{
							alert('— Oops, you missed something: —' + '\n\n' + 'Security Verification missing. Please try again.');
							return false; // Error; cannot continue in this scenario.
						}
						$(submissionButton).attr(disabled),
							ws_plugin__s2member_animateProcessing($(submissionButton));
						return true; // Allow submission.
					});
				}
				/*
				Handles both types of checkout forms.
				*/
				else if(($coForm = $('form#s2member-pro-stripe-sp-checkout-form')).length === 1 || ($coForm = $('form#s2member-pro-stripe-checkout-form')).length === 1)
				{
					(function($coForm)// Handles both types of checkout forms; i.e., Specific Post/Page and also Checkout/Modification forms.
					{
						var coTypeWithDashes = $coForm[0].id.replace(/^s2member\-pro\-stripe\-/, '').replace(/\-form$/, ''),
							coTypeWithUnderscores = coTypeWithDashes.replace(/[^a-z0-9]/gi, '_'); // e.g., `sp_checkout`.

						optionsSection = 'div#s2member-pro-stripe-' + coTypeWithDashes + '-form-options-section',
							optionsSelect = optionsSection + ' select#s2member-pro-stripe-' + coTypeWithDashes + '-options',

							descSection = 'div#s2member-pro-stripe-' + coTypeWithDashes + '-form-description-section',

							couponSection = 'div#s2member-pro-stripe-' + coTypeWithDashes + '-form-coupon-section',
							couponApplyButton = couponSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-coupon-apply',

							registrationSection = 'div#s2member-pro-stripe-' + coTypeWithDashes + '-form-registration-section',
							customFieldsSection = 'div#s2member-pro-stripe-' + coTypeWithDashes + '-form-custom-fields-section',

							billingMethodSection = 'div#s2member-pro-stripe-form-billing-method-section',
							sourceTokenButton = billingMethodSection + ' button#s2member-pro-stripe-' + coTypeWithDashes + '-form-source-token-button',
							sourceTokenSummary = billingMethodSection + ' div#s2member-pro-stripe-' + coTypeWithDashes + '-form-source-token-summary',

							billingAddressSection = 'div#s2member-pro-stripe-' + coTypeWithDashes + '-form-billing-address-section',
							ajaxTaxDiv = billingAddressSection + ' > div#s2member-pro-stripe-' + coTypeWithDashes + '-form-ajax-tax-div',

							captchaSection = 'div#s2member-pro-stripe-' + coTypeWithDashes + '-form-captcha-section',

							submissionSection = 'div#s2member-pro-stripe-' + coTypeWithDashes + '-form-submission-section',
							sourceTokenInput = submissionSection + ' input[name="' + ws_plugin__s2member_escjQAttr('s2member_pro_stripe_' + coTypeWithUnderscores + '[source_token]') + '"]',
							sourceTokenSummaryInput = submissionSection + ' input[name="' + ws_plugin__s2member_escjQAttr('s2member_pro_stripe_' + coTypeWithUnderscores + '[source_token_summary]') + '"]',
							submissionNonceVerification = submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-nonce',
							submissionButton = submissionSection + ' button#s2member-pro-stripe-' + coTypeWithDashes + '-submit';

						/*
						Reset button states; in case of a back button.
						*/
						$(optionsSelect).removeAttr('disabled'), $(couponApplyButton).removeAttr('disabled'),
							$(submissionButton).removeAttr('disabled'), ws_plugin__s2member_animateProcessing($(submissionButton), 'reset');
						/*
						Handle checkout options. Does this form have checkout options?
						*/
						if(!$(optionsSelect + ' option').length)
							$(optionsSection).hide(), $(descSection).show();

						else $(optionsSection).show(), $(descSection).hide(),
							$(optionsSelect).on('change', function(/* Handle checkout option changes. */)
							{
								$(submissionNonceVerification).val('option'),
									$coForm.attr('action', $coForm.attr('action').replace(/#.*$/, '') + '#s2p-form'),
									$coForm.submit(); // Submit form with a new checkout option.
							});
						/*
						Handle the coupon code section. Enabled on this form?
						*/
						if($(submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-coupons-not-required-or-not-possible').length)
							$(couponSection).hide(); // Not accepting coupons on this particular form.

						else $(couponSection).show(), $(couponApplyButton).on('click', function(/* Submit coupon code upon clicking apply button. */)
						{
							$(submissionNonceVerification).val('apply-coupon'),
								$coForm.attr('action', $coForm.attr('action').replace(/#.*$/, '') + '#s2p-form'),
								$coForm.submit(); // Submit form with hash positioning.
						});
						/*
						Handle a user that is already logged into their account.
						*/
						if(S2MEMBER_CURRENT_USER_IS_LOGGED_IN/* User is already logged in? */)
						{
							$(registrationSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-first-name')
								.each(function()
											{
												var $this = $(this), val = $this.val();
												if(!val) $this.val(S2MEMBER_CURRENT_USER_FIRST_NAME);
											});
							$(registrationSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-last-name')
								.each(function()
											{
												var $this = $(this), val = $this.val();
												if(!val) $this.val(S2MEMBER_CURRENT_USER_LAST_NAME);
											});
							$(registrationSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-email').val(S2MEMBER_CURRENT_USER_EMAIL).attr(ariaFalseDis),
								$(registrationSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-username').val(S2MEMBER_CURRENT_USER_LOGIN).attr(ariaFalseDis);

							if(coTypeWithDashes === 'sp-checkout') // Specific Post/Page Access requires an email address.
								$(registrationSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-email').attr(ariaTrue).removeAttr('disabled');

							$(registrationSection + ' > div#s2member-pro-stripe-' + coTypeWithDashes + '-form-password-div').hide(),
								$(registrationSection + ' > div#s2member-pro-stripe-' + coTypeWithDashes + '-form-password-div :input').attr(ariaFalseDis);

							if($.trim($(registrationSection + ' > div#s2member-pro-stripe-' + coTypeWithDashes + '-form-registration-section-title').html()) === 'Create Profile')
								$(registrationSection + ' > div#s2member-pro-stripe-' + coTypeWithDashes + '-form-registration-section-title').html('Your Profile');

							$(customFieldsSection).hide(), $(customFieldsSection + ' :input').attr(ariaFalseDis);
						}
						/*
						Handle the password input field in various scenarios.
						*/
						if($(submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-password-not-required-or-not-possible').length)
						{
							$(registrationSection + ' > div#s2member-pro-stripe-' + coTypeWithDashes + '-form-password-div').hide(),
								$(registrationSection + ' > div#s2member-pro-stripe-' + coTypeWithDashes + '-form-password-div :input').attr(ariaFalseDis);
						}
						else $(registrationSection + ' > div#s2member-pro-stripe-' + coTypeWithDashes + '-form-password-div :input').on('keyup initialize.s2', function()
						{
							ws_plugin__s2member_passwordStrength(
								$(registrationSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-username'),
								$(registrationSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-password1'),
								$(registrationSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-password2'),
								$(registrationSection + ' div#s2member-pro-stripe-' + coTypeWithDashes + '-form-password-strength')
							);
						}).trigger('initialize.s2');
						/*
						Handle tax calulations via tax-related input fields.
						*/
						if($(submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-tax-not-required-or-not-possible').length)
							$(ajaxTaxDiv).hide(), taxMayApply = false; // Tax does NOT even apply.

						else // We need to setup a few handlers.
						{
							cTaxDelay = function(eventTrigger)
							{
								setTimeout(function(){ calculateTax(eventTrigger); }, 10);
							};
							calculateTax = function(eventTrigger) // Calculates tax.
							{
								if(!taxMayApply) return; // Not applicable.

								if(eventTrigger && eventTrigger.interval && document.activeElement
									&& document.activeElement.id === 's2member-pro-stripe-' + coTypeWithDashes + '-country')
									return; // Nothing to do in this special case.

								var attr = $(submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-attr').val(),
									state = $.trim($(billingAddressSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-state').val()),
									country = $.trim($(billingAddressSection + ' select#s2member-pro-stripe-' + coTypeWithDashes + '-country').val()),
									zip = $.trim($(billingAddressSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-zip').val()),
									thisTaxLocation = state + '|' + country + '|' + zip, // Three part location.
									isBitcoin = $.trim($(sourceTokenInput).val()).indexOf('btcrcv_') === 0;

								if(state && country && zip && thisTaxLocation && !isBitcoin && (!cTaxLocation || cTaxLocation !== thisTaxLocation))
								{
									clearTimeout(cTaxTimeout), cTaxTimeout = 0,
										cTaxLocation = thisTaxLocation; // Set current location.
									if(cTaxReq) cTaxReq.abort(); // Abort any existing connections.

									var verifier = 'ZGVmNTAyMDBmMTkxMTEyOTliY2QwY2ExYmQwNGM3MDZlZjkyODk2NDJmNzgwMWIxMjQzMmIwMGIyMTY2NzQzNDI0ODJhZmRhZWU0MzhjOTkyNzIwZDUxNTY3NTRiNjIyYTc0MmI3MGFlMzM2OTMxNmQ3MDMxZWYwNWEzMWM5ODMwZTI0MDRkZjVlOGY4NmUyMDgxZjlmNGVlOGQxZTdlM2IzY2M4MDcwN2RiZTI0NzNjZWUyY2FkMDVmMTVjYWE5YjMxNmFlMDM2YTRhZTExN2JkMWRhMjQzZTA5ZGM5ZDAwM2YwNzA0MTIyZWE4MjRjM2M3MmUx',
										calculating = '<div><img src="' + ws_plugin__s2member_escAttr(preloadAjaxLoader.src) + '" alt="" /> calculating sales tax...</div>',
										ajaxTaxHandler = function(/* Create a new cTaxTimeout with a one second delay. */)
										{
											cTaxReq = $.post('https://www.datanovia.com/en/wp-admin/admin-ajax.php',
																			{
																				'action'                                               : 'ws_plugin__s2member_pro_stripe_ajax_tax',
																				'ws_plugin__s2member_pro_stripe_ajax_tax'              : verifier,
																				'ws_plugin__s2member_pro_stripe_ajax_tax_vars[attr]'   : attr,
																				'ws_plugin__s2member_pro_stripe_ajax_tax_vars[state]'  : state,
																				'ws_plugin__s2member_pro_stripe_ajax_tax_vars[country]': country,
																				'ws_plugin__s2member_pro_stripe_ajax_tax_vars[zip]'    : zip
																			},
																			function(response, textStatus)
																			{
																				clearTimeout(cTaxTimeout), cTaxTimeout = 0;
																				if(typeof response === 'object' && response.hasOwnProperty('tax'))
																				/* translators: `Sales Tax (Today)` and `Total (Today)`. The word `Today` is displayed when/if a trial period is offered. The word `Today` is translated elsewhere. */
																					$(ajaxTaxDiv).html('<div>' + $.sprintf('<strong>Sales Tax%s:</strong> %s<br /><strong>— Total%s:</strong> %s', ((response.trial) ? ' ' + 'Today' : ''), ((response.tax_per) ? '<em>' + response.tax_per + '</em> ( ' + response.cur_symbol + '' + response.tax + ' )' : response.cur_symbol + '' + response.tax), ((response.trial) ? ' ' + 'Today' : ''), response.cur_symbol + '' + response.total) + '</div>');
																			}, 'json');
										};
									$(ajaxTaxDiv).html(calculating), cTaxTimeout = setTimeout(ajaxTaxHandler, ((eventTrigger && eventTrigger.keyCode) ? 1000 : 100));
								}
								else if(!state || !country || !zip || !thisTaxLocation || isBitcoin)
								{
									clearTimeout(cTaxTimeout), cTaxTimeout = 0,
										cTaxLocation = ''; // Reset the current location.
									if(cTaxReq) cTaxReq.abort(); // Abort any existing connections.
									$(ajaxTaxDiv).html(''); // Empty the tax calculation div here also.
								}
							};
							setInterval(function(){ calculateTax({interval: true}); }, 1000), // Helps with things like Google's Autofill feature.
								$(billingAddressSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-state').on('keyup blur', calculateTax).on('cut paste', cTaxDelay),
								$(billingAddressSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-zip').on('keyup blur', calculateTax).on('cut paste', cTaxDelay),
								$(billingAddressSection + ' select#s2member-pro-stripe-' + coTypeWithDashes + '-country').on('change', calculateTax),
								calculateTax(); // Calculate immediately to deal with fields already filled in.
						}
						handleBillingMethod = function(eventTrigger /* eventTrigger is passed by jQuery for DOM events. */)
						{
							if($(submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-payment-not-required-or-not-possible').length)
								$(sourceTokenInput).val('free'); // No payment required in this very special case.

							var sourceToken = $(sourceTokenInput).val(/* Source token from Stripe. */);

							if(sourceToken/* They have now supplied a source token? */)
							{
								if(sourceToken === 'free' /* Special source token value. */)
								{
									$(billingMethodSection).hide(), // Hide billing method section.
										$(billingMethodSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div').hide(),
										$(billingMethodSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div :input').attr(ariaFalse);
								}
								else // We need to display the billing method section in all other cases.
								{
									$(billingMethodSection).show(), // Show billing method section.
										$(billingMethodSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div').show(),
										$(billingMethodSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div :input').attr(ariaTrue);
								}
								if(sourceToken !== 'free' && taxMayApply && sourceToken.indexOf('btcrcv_') !== 0)
								{
									$(billingAddressSection).show(), // Show billing address section.
										$(billingAddressSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div').show(),
										$(billingAddressSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div :input').attr(ariaTrue);
								}
								else // There is no reason to collect tax information in this case.
								{
									$(billingAddressSection).hide(), // Hide billing address section.
										$(billingAddressSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div').hide(),
										$(billingAddressSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div :input').attr(ariaFalse);
								}
								if(eventTrigger) $(submissionSection + ' button#s2member-pro-stripe-' + coTypeWithDashes + '-submit').focus();
							}
							else if(!sourceToken/* Else there is no Billing Method supplied. */)
							{
								$(billingMethodSection).show(), // Show billing method section.
									$(billingMethodSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div').show(),
									$(billingMethodSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div :input').attr(ariaTrue);

								$(billingAddressSection).hide(), // Hide billing address section.
									$(billingAddressSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div').hide(),
									$(billingAddressSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div :input').attr(ariaFalse);
							}
						};
						handleBillingMethod(); // Handle billing method immediately to deal with fields already filled in.

						//!!! ^^^We don't use tokens anymore... 
						if(taxMayApply)
						{
							$(billingAddressSection).show(), // Show billing address section.
								$(billingAddressSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div').show(),
								$(billingAddressSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div :input').attr(ariaTrue);
						}
						else // There is no reason to collect tax information in this case.
						{
							$(billingAddressSection).hide(), // Hide billing address section.
								$(billingAddressSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div').hide(),
								$(billingAddressSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div :input').attr(ariaFalse);
						}

						//!!! "free" check to hide the billing method when 100% off coupons.
						if($(submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-payment-not-required-or-not-possible').length)
						{
							var isFree = true;
							$(billingMethodSection).hide(), // Hide billing method section.
								$(billingMethodSection + ' > div').hide(),
								$(billingMethodSection + ' > label').hide();

							$(billingAddressSection).hide(), // Hide billing address section.
								$(billingAddressSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div').hide(),
								$(billingAddressSection + ' > div.s2member-pro-stripe-' + coTypeWithDashes + '-form-div :input').attr(ariaFalse);
						}

						$(sourceTokenButton).on('click', function() // Stripe integration.
						{
							var isBuyNow = $(submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-is-buy-now-amount-in-cents').length > 0,
								validateZipCode = $(submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-should-validate-zipcode').val() == '1',
								collectBillingAddress = $(submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-should-collect-billing-address').val() == '1',
								collectShippingAddress = $(submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-should-collect-shipping-address').val() == '1',
								acceptBitcoin = isBuyNow && $(submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-is-buy-now-bitcoin-accepted').length > 0,
								isBuyNowAmountInCents = isBuyNow ? parseInt($.trim($(submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-is-buy-now-amount-in-cents').val())) : 0,
								isBuyNowCurrency = isBuyNow ? $.trim($(submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-is-buy-now-currency').val()).toUpperCase() : '',
								isBuyNowDesc = isBuyNow ? $.trim($(submissionSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-is-buy-now-desc').val()) : '',
								stripeImage = '';

							if(isBuyNow && (isNaN(isBuyNowAmountInCents) || isBuyNowAmountInCents <= 0))
								isBuyNow = false, acceptBitcoin = false, isBuyNowAmountInCents = 0, isBuyNowCurrency = '', isBuyNowDesc = '';

							var getSourceToken = StripeCheckout.configure
							({
								image      : stripeImage ? stripeImage : undefined,
								locale     : 'auto', // Based on visitor's country.

								amount     : isBuyNow ? isBuyNowAmountInCents : undefined,
								currency   : isBuyNow ? isBuyNowCurrency : undefined,
								description: isBuyNow ? isBuyNowDesc : undefined,
								bitcoin    : isBuyNow && acceptBitcoin,

								key            : 'pk_live_ohTSIAosxLpgmwjwCPs2JefP',
								allowRememberMe: '1' == '1',
								panelLabel     : 'Add',
								zipCode        : validateZipCode, billingAddress : collectBillingAddress, shippingAddress: collectShippingAddress,
								email          : $(registrationSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-email').val(),

								token: function(token) // Callback handler.
								{
									$(sourceTokenInput).val(token.id), $(sourceTokenSummaryInput).val(buildSourceTokenTextSummary(token)),
										$(sourceTokenSummary).html(ws_plugin__s2member_escHtml(buildSourceTokenTextSummary(token))),
										handleBillingMethod(); // Adjust billing methods fields now also.
								}
							});
							getSourceToken.open(); // Open Stripe overlay.
						});
						$coForm.on('submit', function(/* Form validation. */)
						{
							if($.inArray($(submissionNonceVerification).val(), ['option', 'apply-coupon']) === -1)
							{
								var context = this, label = '', error = '', errors = '',
									$recaptchaResponse = $(captchaSection + ' input#recaptcha_response_field, '+captchaSection+' #g-recaptcha-response'),
									$password1 = $(registrationSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-password1[aria-required="true"]'),
									$password2 = $(registrationSection + ' input#s2member-pro-stripe-' + coTypeWithDashes + '-password2');

								$(':input', context)
									.each(function(/* Go through them all together. */)
												{
													var id = $.trim($(this).attr('id')).replace(/---[0-9]+$/g, ''/* Remove numeric suffixes. */);
													if(id && (label = $.trim($('label[for="' + id.replace(/-(month|year)/, '') + '"]', context).first().children('span').first().text().replace(/[\r\n\t]+/g, ' '))))
													{
														if(error = ws_plugin__s2member_validationErrors(label, this, context))
															errors += error + '\n\n'/* Collect errors. */;
													}
												});
								if((errors = $.trim(errors)))
								{
									alert('— Oops, you missed something: —' + '\n\n' + errors);
									return false; // Error; cannot continue in this scenario.
								}
								else if($password1.length && $.trim($password1.val()) !== $.trim($password2.val()))
								{
									alert('— Oops, you missed something: —' + '\n\n' + 'Passwords do not match up. Please try again.');
									return false; // Error; cannot continue in this scenario.
								}
								else if($password1.length && $.trim($password1.val()).length < ws_plugin__s2member_passwordMinLength())
								{
									alert('— Oops, you missed something: —' + '\n\n' + 'Password MUST be at least 8 characters. Please try again.');
									return false;
								}
								else if($password1.length && ws_plugin__s2member_passwordStrengthMeter($.trim($password1.val()), $.trim($password2.val()), true) < ws_plugin__s2member_passwordMinStrengthScore())
								{
									alert('— Oops, you missed something: —' + '\n\n' + 'Password strength MUST be `good` or `strong` (i.e., use numbers, letters, and mixed caSe). Please try again.');
									return false;
								}
								else if($recaptchaResponse.length && !$recaptchaResponse.val())
								{
									alert('— Oops, you missed something: —' + '\n\n' + 'Security Verification missing. Please try again.');
									return false; // Error; cannot continue in this scenario.
								}
								// $(optionsSelect).attr(disabled); // Not an option selection.
								//!!! Bug fix. Don't disable, because that prevents it from being submitted.
							}
							$(couponApplyButton).attr(disabled),
								$(submissionButton).attr(disabled), ws_plugin__s2member_animateProcessing($(submissionButton));
							return true; // Allow submission.
						});
					})($coForm);
				}
				var buildSourceTokenTextSummary = function(token, args)
				{
					if(typeof token !== 'object') return '';
					// `args` contains billing/shipping address.

					if(token.type === 'card' && token.card && token.card.brand && token.card.last4)
						return token.card.brand + ': xxxx-xxxx-xxxx-' + token.card.last4;

					if(token.type === 'alipay_account' && token.alipay_account && token.alipay_account.username)
						return 'Alipay: ' + token.alipay_account.username;

					if(token.type === 'bank_account' && token.bank_account && token.bank_account.bank_name && token.bank_account.last4)
						return token.bank_account.bank_name + ': xxxx...' + token.bank_account.last4;

					if(token.type === 'source_bitcoin' && token.bitcoin && token.bitcoin.address)
						return 'Bitcoin: ' + token.bitcoin.address;

					return 'Token: ' + token.id;
				};
				/*
				Jump to responses.
				*/
				$('div#s2member-pro-stripe-form-response')
					.each(function()
								{
									scrollTo(0, $(this).offset().top - 100);
								});

				// Stripe SCA update.
				var form = document.getElementsByClassName('s2member-pro-stripe-form')[0];
				var isFree = ($('input#s2member-pro-stripe-sp-checkout-payment-not-required-or-not-possible').length || $('input#s2member-pro-stripe-checkout-payment-not-required-or-not-possible').length) ? true : false;
				if (form && !isFree) {
					var stripe = Stripe('pk_live_ohTSIAosxLpgmwjwCPs2JefP', {
						apiVersion: '2019-10-08',
					});
					var elements = stripe.elements();
					var piSecret = jQuery('#s2member-pro-stripe-form-pi-secret').val();
					var setiSecret = jQuery('#s2member-pro-stripe-form-seti-secret').val();

					// Do we have a Setup Intent with status require_action?
					if (setiSecret) {
						stripe.handleCardSetup(
							setiSecret
						).then(function(result) {
							// Handle result.error or result.setupIntent
							if (result.error) {
								// Display result.error.message in UI.
								var errorElement = document.getElementById('s2member-pro-stripe-form-card-errors');
								errorElement.textContent = result.error.message;
							} else {
								// The SetupIntent has successfully been authorized.
								// Update Setup Intent hidden field with ID.
								jQuery('#s2member-pro-stripe-form-seti-id').val(result.setupIntent.id);

								// Make it more obvious that something is happening, and just wait...
								jQuery('.s2member-pro-stripe-submit')
									.prop('disabled', true)
									.addClass('ws-plugin--s2member-animate-processing');
								jQuery(form).addClass('s2member-pro-stripe-form-disabled');
								jQuery('#s2member-pro-stripe-form-response')
									.removeClass('s2member-pro-stripe-form-response-error')
									.addClass('s2member-pro-stripe-form-response-info')
									.text('Please wait. Don´t close or refresh the window. Processing...');
								
								// Submit the form
								form.submit();
							}
						});
					}

					// Do we have a Payment Intent with status require_action?
					if (piSecret) {
						// If there's a subscription ID, it's a subscription
						// then payment intent's confirmation_method will be set to "automatic", so use handleCardPayment
						// else it's a single payment with confirmation_method set to "manual", so use handleCardAction.
						if (jQuery('#s2member-pro-stripe-form-sub-id').val()) {
							handleCardResult = stripe.handleCardPayment(piSecret);
						}	else {
							handleCardResult = stripe.handleCardAction(piSecret);
						}

						handleCardResult.then(function(result) {
							// Handle result.error or result.paymentIntent
							if (result.error) {
								// Display result.error.message in UI.
								var errorElement = document.getElementById('s2member-pro-stripe-form-card-errors');
								errorElement.textContent = result.error.message;
							} else {
								// The PaymentIntent has successfully been authorized.
								// Update Payment Intent hidden field with ID.
								jQuery('#s2member-pro-stripe-form-pi-id').val(result.paymentIntent.id);

								// Make it more obvious that something is happening, and just wait...
								jQuery('.s2member-pro-stripe-submit')
									.prop('disabled', true)
									.addClass('ws-plugin--s2member-animate-processing');
								jQuery(form).addClass('s2member-pro-stripe-form-disabled');
								jQuery('#s2member-pro-stripe-form-response')
									.removeClass('s2member-pro-stripe-form-response-error')
									.addClass('s2member-pro-stripe-form-response-info')
									.text('Please wait. Don´t close or refresh the window. Processing...');
								
								// Submit the form
								form.submit();
							}
						});
					}

					// Options when creating an Element.
					var style = {
						base: {
							fontSize: '17px',
							color: '#333',
						}
					};
					var hideZip = '0' == 1 ? false : true;
					
					// Create an instance of the card Element.
					var cardElement = elements.create('card', {
						style: style,
						hidePostalCode: hideZip,
					});

					// Add an instance of the card Element into the `card-element` div.
					cardElement.mount('#s2member-pro-stripe-form-card-element');

					// Listen to change events on the card Element and display any errors.
					cardElement.addEventListener('change', function(event) {
						var displayError = document.getElementById('s2member-pro-stripe-form-card-errors');
						if (event.error) {
							displayError.textContent = event.error.message;
						} else {
							displayError.textContent = '';
						}
					});

					// Control form submit.
					form.addEventListener('submit', function(event) {
						event.preventDefault();

						var fullName = jQuery('.s2member-pro-stripe-first-name').val() + ' ' + jQuery('.s2member-pro-stripe-last-name').val();
						var emailAddress = jQuery('.s2member-pro-stripe-email').val();
						var addrStreet = jQuery('.s2member-pro-stripe-street').val();
						var addrCity = jQuery('.s2member-pro-stripe-city').val();
						var addrState = jQuery('.s2member-pro-stripe-state').val();
						var addrCountry = jQuery('.s2member-pro-stripe-country').val();
						var addrZip = jQuery('.s2member-pro-stripe-zip').val();
						var billAddr = {
							line1: addrStreet,
							city: addrCity,
							state: addrState,
							country: addrCountry,
							postal_code: addrZip,
						};

						// Create the Payment Method.
						stripe.createPaymentMethod(
							'card',
							cardElement, 
							{ 
								billing_details: {
									email: emailAddress,
									name: fullName,	
									address: addrState ? billAddr : null,
								}
							}
						).then(function(result) {
							if (result.error) {
								// Display result.error.message in UI.
								jQuery('#s2member-pro-stripe-form-card-errors').text(result.error.message);
								jQuery('.s2member-pro-stripe-submit')
									.prop('disabled', false)
									.removeClass('ws-plugin--s2member-animate-processing');
							} else {
								// The PaymentMethod has successfully been created.
								// Update Payment Method hidden field with ID.
								jQuery('#s2member-pro-stripe-form-pm-id').val(result.paymentMethod.id);
								
								// Submit the form
								form.submit();
							}
						}).catch(console.error.bind(console));
					});
				}
			}
		}
	});

var S2MEMBER_PRO_AUTHNET_GATEWAY = true;
jQuery(document).ready(function(y){var e,p,i,l,o,I,x,v={"aria-required":"true"},b={"aria-required":"false"},z={disabled:"disabled"},g={"aria-required":"false",disabled:"disabled"};x=new Image(),x.src='https://www.datanovia.com/en/wp-content/plugins/s2member/src/images/ajax-loader.gif';if(y("form.s2member-pro-authnet-registration-form").length>1||y("form.s2member-pro-authnet-checkout-form").length>1||y("form.s2member-pro-authnet-sp-checkout-form").length>1){return alert("Detected more than one s2Member Pro-Form.\n\nPlease use only ONE s2Member Pro-Form Shortcode on each Post/Page. Attempting to serve more than one Pro-Form on each Post/Page (even w/ DHTML) may result in unexpected/broken functionality.")}if((e=y("form#s2member-pro-authnet-cancellation-form")).length===1){var L="div#s2member-pro-authnet-cancellation-form-captcha-section",m="div#s2member-pro-authnet-cancellation-form-submission-section",u=y(m+" button#s2member-pro-authnet-cancellation-submit");ws_plugin__s2member_animateProcessing(u,"reset"),u.removeAttr("disabled");e.submit(function(){var R=this,P="",O="",S="";var Q=y(L+" input#recaptcha_response_field, "+L+" #g-recaptcha-response");y(":input",R).each(function(){var T=y.trim(y(this).attr("id")).replace(/---[0-9]+$/g,"");if(T&&(P=y.trim(y('label[for="'+T+'"]',R).first().children("span").first().text().replace(/[\r\n\t]+/g," ")))){if(O=ws_plugin__s2member_validationErrors(P,this,R)){S+=O+"\n\n"}}});if(S=y.trim(S)){alert('— Oops, you missed something: —\n\n'+S);return false}else{if(Q.length&&!Q.val()){alert('— Oops, you missed something: —\n\nSecurity Verification missing. Please try again.');return false}}u.attr(z),ws_plugin__s2member_animateProcessing(u);return true})}else{if((p=y("form#s2member-pro-authnet-update-form")).length===1){var s,t="div#s2member-pro-authnet-update-form-billing-method-section",F="div#s2member-pro-authnet-update-form-billing-address-section",k=t+' input[name="s2member_pro_authnet_update[card_type]"]',L="div#s2member-pro-authnet-update-form-captcha-section",m="div#s2member-pro-authnet-update-form-submission-section",u=y(m+" button#s2member-pro-authnet-update-submit");ws_plugin__s2member_animateProcessing(u,"reset"),u.removeAttr("disabled");(s=function(O){var P=y(k+":checked").val();if(y.inArray(P,["Visa","MasterCard","Amex","Discover"])!==-1){y(t+" > div.s2member-pro-authnet-update-form-div").show();y(t+" > div.s2member-pro-authnet-update-form-div :input").attr(v);y(t+" > div#s2member-pro-authnet-update-form-card-start-date-issue-number-div").hide();y(t+" > div#s2member-pro-authnet-update-form-card-start-date-issue-number-div :input").attr(b);y(F+" > div.s2member-pro-authnet-update-form-div").show();y(F+" > div.s2member-pro-authnet-update-form-div :input").attr(v);y(F).show(),(O)?y(t+" input#s2member-pro-authnet-update-card-number").focus():null}else{if(y.inArray(P,["Maestro","Solo"])!==-1){y(t+" > div.s2member-pro-authnet-update-form-div").show();y(t+" > div.s2member-pro-authnet-update-form-div :input").attr(v);y(F+" > div.s2member-pro-authnet-update-form-div").show();y(F+" > div.s2member-pro-authnet-update-form-div :input").attr(v);y(F).show(),(O)?y(t+" input#s2member-pro-authnet-update-card-number").focus():null}else{if(!P){y(t+" > div.s2member-pro-authnet-update-form-div").hide();y(t+" > div.s2member-pro-authnet-update-form-div :input").attr(b);y(t+" > div#s2member-pro-authnet-update-form-card-type-div").show();y(t+" > div#s2member-pro-authnet-update-form-card-type-div :input").attr(v);y(F+" > div.s2member-pro-authnet-update-form-div").hide();y(F+" > div.s2member-pro-authnet-update-form-div :input").attr(b);y(F).hide(),(O)?y(m+" button#s2member-pro-authnet-update-submit").focus():null}}}})();y(k).click(s).change(s);p.submit(function(){var R=this,P="",O="",S="";var Q=y(L+" input#recaptcha_response_field, "+L+" #g-recaptcha-response");if(!y(k+":checked").val()){alert('Please choose a Billing Method.');return false}y(":input",R).each(function(){var T=y.trim(y(this).attr("id")).replace(/---[0-9]+$/g,"");if(T&&(P=y.trim(y('label[for="'+T.replace(/-(month|year)/,"")+'"]',R).first().children("span").first().text().replace(/[\r\n\t]+/g," ")))){if(O=ws_plugin__s2member_validationErrors(P,this,R)){S+=O+"\n\n"}}});if(S=y.trim(S)){alert('— Oops, you missed something: —\n\n'+S);return false}else{if(Q.length&&!Q.val()){alert('— Oops, you missed something: —\n\nSecurity Verification missing. Please try again.');return false}}u.attr(z),ws_plugin__s2member_animateProcessing(u);return true})}else{if((i=y("form#s2member-pro-authnet-registration-form")).length===1){var h,J,q,a="div#s2member-pro-authnet-registration-form-options-section",D="div#s2member-pro-authnet-registration-form-description-section",K="div#s2member-pro-authnet-registration-form-registration-section",L="div#s2member-pro-authnet-registration-form-captcha-section",m="div#s2member-pro-authnet-registration-form-submission-section",j=m+" input#s2member-pro-authnet-registration-nonce",u=y(m+" button#s2member-pro-authnet-registration-submit");ws_plugin__s2member_animateProcessing(u,"reset"),u.removeAttr("disabled");(h=function(O){if(!y(a+" select#s2member-pro-authnet-registration-options option").length){y(a).hide();y(D).show()}else{y(a).show();y(D).hide();y(a+" select#s2member-pro-authnet-registration-options").change(function(){y(j).val("option");i.attr("action",i.attr("action").replace(/#.*$/,"")+"#s2p-form");i.submit()})}})();(J=function(O){if(y(m+" input#s2member-pro-authnet-registration-names-not-required-or-not-possible").length){y(K+" > div#s2member-pro-authnet-registration-form-first-name-div").hide();y(K+" > div#s2member-pro-authnet-registration-form-first-name-div :input").attr(g);y(K+" > div#s2member-pro-authnet-registration-form-last-name-div").hide();y(K+" > div#s2member-pro-authnet-registration-form-last-name-div :input").attr(g)}})();(q=function(O){if(y(m+" input#s2member-pro-authnet-registration-password-not-required-or-not-possible").length){y(K+" > div#s2member-pro-authnet-registration-form-password-div").hide();y(K+" > div#s2member-pro-authnet-registration-form-password-div :input").attr(g)}})();y(K+" > div#s2member-pro-authnet-registration-form-password-div :input").on("keyup initialize.s2",function(){ws_plugin__s2member_passwordStrength(y(K+" input#s2member-pro-authnet-registration-username"),y(K+" input#s2member-pro-authnet-registration-password1"),y(K+" input#s2member-pro-authnet-registration-password2"),y(K+" div#s2member-pro-authnet-registration-form-password-strength"))}).trigger("initialize.s2");i.submit(function(){if(y.inArray(y(j).val(),["option"])===-1){var R=this,P="",O="",U="";var Q=y(L+" input#recaptcha_response_field, "+L+" #g-recaptcha-response");var T=y(K+' input#s2member-pro-authnet-registration-password1[aria-required="true"]');var S=y(K+" input#s2member-pro-authnet-registration-password2");y(":input",R).each(function(){var V=y.trim(y(this).attr("id")).replace(/---[0-9]+$/g,"");if(V&&(P=y.trim(y('label[for="'+V+'"]',R).first().children("span").first().text().replace(/[\r\n\t]+/g," ")))){if(O=ws_plugin__s2member_validationErrors(P,this,R)){U+=O+"\n\n"}}});if(U=y.trim(U)){alert('— Oops, you missed something: —\n\n'+U);return false}else{if(T.length&&y.trim(T.val())!==y.trim(S.val())){alert('— Oops, you missed something: —\n\nPasswords do not match up. Please try again.');return false}else{if(T.length&&y.trim(T.val()).length<ws_plugin__s2member_passwordMinLength()){alert('— Oops, you missed something: —\n\nPassword MUST be at least 8 characters. Please try again.');return false}else{if(T.length&&ws_plugin__s2member_passwordStrengthMeter(y.trim(T.val()),y.trim(S.val()),true)<ws_plugin__s2member_passwordMinStrengthScore()){alert('— Oops, you missed something: —\n\nPassword strength MUST be `good` or `strong` (i.e., use numbers, letters, and mixed caSe). Please try again.');return false}else{if(Q.length&&!Q.val()){alert('— Oops, you missed something: —\n\nSecurity Verification missing. Please try again.');return false}}}}}}u.attr(z),ws_plugin__s2member_animateProcessing(u);return true})}else{if((l=y("form#s2member-pro-authnet-sp-checkout-form")).length===1){var h,C,H,r=true,G,n,f,A,c,B,s,a="div#s2member-pro-authnet-sp-checkout-form-options-section",D="div#s2member-pro-authnet-sp-checkout-form-description-section",E="div#s2member-pro-authnet-sp-checkout-form-coupon-section",M=E+" input#s2member-pro-authnet-sp-checkout-coupon-apply",K="div#s2member-pro-authnet-sp-checkout-form-registration-section",t="div#s2member-pro-authnet-sp-checkout-form-billing-method-section",k=t+' input[name="s2member_pro_authnet_sp_checkout[card_type]"]',F="div#s2member-pro-authnet-sp-checkout-form-billing-address-section",w=y(F+" > div#s2member-pro-authnet-sp-checkout-form-ajax-tax-div"),L="div#s2member-pro-authnet-sp-checkout-form-captcha-section",m="div#s2member-pro-authnet-sp-checkout-form-submission-section",j=m+" input#s2member-pro-authnet-sp-checkout-nonce",d=m+" button#s2member-pro-authnet-sp-checkout-submit";ws_plugin__s2member_animateProcessing(y(d),"reset"),y(d).removeAttr("disabled"),y(M).removeAttr("disabled");(h=function(O){if(!y(a+" select#s2member-pro-authnet-sp-checkout-options option").length){y(a).hide();y(D).show()}else{y(a).show();y(D).hide();y(a+" select#s2member-pro-authnet-sp-checkout-options").change(function(){y(j).val("option");l.attr("action",l.attr("action").replace(/#.*$/,"")+"#s2p-form");l.submit()})}})();(C=function(O){if(y(m+" input#s2member-pro-authnet-sp-checkout-coupons-not-required-or-not-possible").length){y(E).hide()}else{y(E).show()}})();(H=function(O){if(y(m+" input#s2member-pro-authnet-sp-checkout-tax-not-required-or-not-possible").length){w.hide(),r=false}})();(G=function(P){if(r&&!(P&&P.interval&&document.activeElement.id==="s2member-pro-authnet-sp-checkout-country")){var O=y(m+" input#s2member-pro-authnet-sp-checkout-attr").val();var S=y.trim(y(F+" input#s2member-pro-authnet-sp-checkout-state").val());var T=y(F+" select#s2member-pro-authnet-sp-checkout-country").val();var R=y.trim(y(F+" input#s2member-pro-authnet-sp-checkout-zip").val());var Q=S+"|"+T+"|"+R;if(S&&T&&R&&Q&&(!c||c!==Q)&&(c=Q)){(A)?A.abort():null,clearTimeout(f),f=null;w.html('<div><img src="https://www.datanovia.com/en/wp-content/plugins/s2member/src/images/ajax-loader.gif" alt="Calculating Sales Tax..." /> calculating sales tax...</div>');f=setTimeout(function(){A=y.post('https://www.datanovia.com/en/wp-admin/admin-ajax.php',{action:"ws_plugin__s2member_pro_authnet_ajax_tax",ws_plugin__s2member_pro_authnet_ajax_tax:'ZGVmNTAyMDA0Y2EzYWRkM2ViZDQxODhmODY4ZjM0NmU1Mzg4MWI5YTU2N2YwY2JjNThhNzFjZTcxNTA1Y2JiMDViNDEzOGU3MzIzNTkxYTZkY2FiM2E3ZjNmYzNhM2RjNmUzOWY5NGU2OTRhMTI4ZGJhZmFkZDE1NWM1NjdiMDM2ZGQ1MDhkMzhiNzg4MzI1MGEzOWM0ZGQ1MmRlMzZiM2NmZDJkZDU2NDY4Mjk5ZjljNjJmYmJmMWRjNmU4MjBjODhkMmRhMTJiNmFhNGE3NWVlN2M3N2RiYWI0ODEzZmVhODIyNjFhMjExOWEyNjFjNWM5ZjM4Y2M',"ws_plugin__s2member_pro_authnet_ajax_tax_vars[attr]":O,"ws_plugin__s2member_pro_authnet_ajax_tax_vars[state]":S,"ws_plugin__s2member_pro_authnet_ajax_tax_vars[country]":T,"ws_plugin__s2member_pro_authnet_ajax_tax_vars[zip]":R},function(U){clearTimeout(f),f=null;try{w.html("<div>"+y.sprintf('<strong>Sales Tax%s:</strong> %s<br /><strong>— Total%s:</strong> %s',((U.trial)?' Today':""),((U.tax_per)?"<em>"+U.tax_per+"</em> ( "+U.cur_symbol+""+U.tax+" )":U.cur_symbol+""+U.tax),((U.trial)?' Today':""),U.cur_symbol+""+U.total)+"</div>")}catch(V){}},"json")},((P&&P.keyCode)?1000:100))}else{if(!S||!T||!R||!Q){w.html(""),c=null}}}})();n=function(O){setTimeout(function(){G(O)},10)};y(F+" input#s2member-pro-authnet-sp-checkout-state").bind("keyup blur",G).bind("cut paste",n);y(F+" input#s2member-pro-authnet-sp-checkout-zip").bind("keyup blur",G).bind("cut paste",n);y(F+" select#s2member-pro-authnet-sp-checkout-country").bind("change",G);setInterval(function(){G({interval:true})},1000);(B=function(O){if(S2MEMBER_CURRENT_USER_IS_LOGGED_IN){y(K+" input#s2member-pro-authnet-sp-checkout-first-name").each(function(){var P=y(this),Q=P.val();(!Q)?P.val(S2MEMBER_CURRENT_USER_FIRST_NAME):null});y(K+" input#s2member-pro-authnet-sp-checkout-last-name").each(function(){var P=y(this),Q=P.val();(!Q)?P.val(S2MEMBER_CURRENT_USER_LAST_NAME):null});y(K+" input#s2member-pro-authnet-sp-checkout-email").each(function(){var P=y(this),Q=P.val();(!Q)?P.val(S2MEMBER_CURRENT_USER_EMAIL):null})}})();(s=function(O){if(y(m+" input#s2member-pro-authnet-sp-checkout-payment-not-required-or-not-possible").length){y(k).val(["Free"])}var P=y(k+":checked").val();if(y.inArray(P,["Free"])!==-1){y(t).hide(),y(F).hide();y(t+" > div.s2member-pro-authnet-sp-checkout-form-div").hide();y(t+" > div.s2member-pro-authnet-sp-checkout-form-div :input").attr(b);y(F+" > div.s2member-pro-authnet-sp-checkout-form-div").hide();y(F+" > div.s2member-pro-authnet-sp-checkout-form-div :input").attr(b);(!r)?w.hide():null;(O)?y(m+" button#s2member-pro-authnet-sp-checkout-submit").focus():null}else{if(y.inArray(P,["Visa","MasterCard","Amex","Discover"])!==-1){y(t).show(),y(F).show();y(t+" > div.s2member-pro-authnet-sp-checkout-form-div").show();y(t+" > div.s2member-pro-authnet-sp-checkout-form-div :input").attr(v);y(t+" > div#s2member-pro-authnet-sp-checkout-form-card-start-date-issue-number-div").hide();y(t+" > div#s2member-pro-authnet-sp-checkout-form-card-start-date-issue-number-div :input").attr(b);y(F+" > div.s2member-pro-authnet-sp-checkout-form-div").show();y(F+" > div.s2member-pro-authnet-sp-checkout-form-div :input").attr(v);(!r)?w.hide():null;(O)?y(t+" input#s2member-pro-authnet-sp-checkout-card-number").focus():null}else{if(y.inArray(P,["Maestro","Solo"])!==-1){y(t).show(),y(F).show();y(t+" > div.s2member-pro-authnet-sp-checkout-form-div").show();y(t+" > div.s2member-pro-authnet-sp-checkout-form-div :input").attr(v);y(F+" > div.s2member-pro-authnet-sp-checkout-form-div").show();y(F+" > div.s2member-pro-authnet-sp-checkout-form-div :input").attr(v);(!r)?w.hide():null;(O)?y(t+" input#s2member-pro-authnet-sp-checkout-card-number").focus():null}else{if(!P){y(t).show(),y(F).hide();y(t+" > div.s2member-pro-authnet-sp-checkout-form-div").hide();y(t+" > div.s2member-pro-authnet-sp-checkout-form-div :input").attr(b);y(t+" > div#s2member-pro-authnet-sp-checkout-form-card-type-div").show();y(t+" > div#s2member-pro-authnet-sp-checkout-form-card-type-div :input").attr(v);y(F+" > div.s2member-pro-authnet-sp-checkout-form-div").hide();y(F+" > div.s2member-pro-authnet-sp-checkout-form-div :input").attr(b);(!r)?w.hide():null;(O)?y(m+" button#s2member-pro-authnet-sp-checkout-submit").focus():null}}}}H()})();y(k).click(s).change(s);y(M).click(function(){y(j).val("apply-coupon"),l.submit()});l.submit(function(){if(y.inArray(y(j).val(),["option","apply-coupon"])===-1){var R=this,P="",O="",S="";var Q=y(L+" input#recaptcha_response_field, "+L+" #g-recaptcha-response");if(!y(k+":checked").val()){alert('Please choose a Billing Method.');return false}y(":input",R).each(function(){var T=y.trim(y(this).attr("id")).replace(/---[0-9]+$/g,"");if(T&&(P=y.trim(y('label[for="'+T.replace(/-(month|year)/,"")+'"]',R).first().children("span").first().text().replace(/[\r\n\t]+/g," ")))){if(O=ws_plugin__s2member_validationErrors(P,this,R)){S+=O+"\n\n"}}});if(S=y.trim(S)){alert('— Oops, you missed something: —\n\n'+S);return false}else{if(Q.length&&!Q.val()){alert('— Oops, you missed something: —\n\nSecurity Verification missing. Please try again.');return false}}}y(d).attr(z),ws_plugin__s2member_animateProcessing(y(d)),y(M).attr(z);return true})}else{if((o=y("form#s2member-pro-authnet-checkout-form")).length===1){var h,C,H,r=true,G,n,f,A,c,q,s,B,a="div#s2member-pro-authnet-checkout-form-options-section",D="div#s2member-pro-authnet-checkout-form-description-section",E="div#s2member-pro-authnet-checkout-form-coupon-section",M=E+" input#s2member-pro-authnet-checkout-coupon-apply",K="div#s2member-pro-authnet-checkout-form-registration-section",N="div#s2member-pro-authnet-checkout-form-custom-fields-section",t="div#s2member-pro-authnet-checkout-form-billing-method-section",k=t+' input[name="s2member_pro_authnet_checkout[card_type]"]',F="div#s2member-pro-authnet-checkout-form-billing-address-section",w=y(F+" > div#s2member-pro-authnet-checkout-form-ajax-tax-div"),L="div#s2member-pro-authnet-checkout-form-captcha-section",m="div#s2member-pro-authnet-checkout-form-submission-section",j=m+" input#s2member-pro-authnet-checkout-nonce",d=m+" button#s2member-pro-authnet-checkout-submit";ws_plugin__s2member_animateProcessing(y(d),"reset"),y(d).removeAttr("disabled"),y(M).removeAttr("disabled");(h=function(O){if(!y(a+" select#s2member-pro-authnet-checkout-options option").length){y(a).hide();y(D).show()}else{y(a).show();y(D).hide();y(a+" select#s2member-pro-authnet-checkout-options").change(function(){y(j).val("option");o.attr("action",o.attr("action").replace(/#.*$/,"")+"#s2p-form");o.submit()})}})();(C=function(O){if(y(m+" input#s2member-pro-authnet-checkout-coupons-not-required-or-not-possible").length){y(E).hide()}else{y(E).show()}})();(H=function(O){if(y(m+" input#s2member-pro-authnet-checkout-tax-not-required-or-not-possible").length){w.hide(),r=false}})();(G=function(P){if(r&&!(P&&P.interval&&document.activeElement.id==="s2member-pro-authnet-checkout-country")){var O=y(m+" input#s2member-pro-authnet-checkout-attr").val();var S=y.trim(y(F+" input#s2member-pro-authnet-checkout-state").val());var T=y(F+" select#s2member-pro-authnet-checkout-country").val();var R=y.trim(y(F+" input#s2member-pro-authnet-checkout-zip").val());var Q=S+"|"+T+"|"+R;if(S&&T&&R&&Q&&(!c||c!==Q)&&(c=Q)){(A)?A.abort():null,clearTimeout(f),f=null;w.html('<div><img src="https://www.datanovia.com/en/wp-content/plugins/s2member/src/images/ajax-loader.gif" alt="Calculating Sales Tax..." /> calculating sales tax...</div>');f=setTimeout(function(){A=y.post('https://www.datanovia.com/en/wp-admin/admin-ajax.php',{action:"ws_plugin__s2member_pro_authnet_ajax_tax",ws_plugin__s2member_pro_authnet_ajax_tax:'ZGVmNTAyMDBhMDkyMjc1NmQwMzFhNjMyMDM5NzlhN2Q3MmEyMjM4OWIxZTkxYTA1NzM3NGY5ZmQ1Y2Y0MGVkMDQ5MmJlOGIyYWMwNjM3OThmMWQ3MjkxYjQ2ZTU5NTkwZGYyN2JmOTUzZWJlN2YzZTZiYjc1NTMwZWIzNzc3Y2U1ODU1YTdhNWM2OTExZDc2ZTYwYjZlMDNjN2FiY2U3MTdhZjZjNTEwMDk4YTFmNWNiNDY3YzIxNWUzMTQ1ODY1MjY4OTE4ODZhMTFmZmE3ZjhiMDUyN2Y2Mzk4YzU5M2QzYzhjZTFhNGQwZjljM2Y2NzdhMjBjMzk',"ws_plugin__s2member_pro_authnet_ajax_tax_vars[attr]":O,"ws_plugin__s2member_pro_authnet_ajax_tax_vars[state]":S,"ws_plugin__s2member_pro_authnet_ajax_tax_vars[country]":T,"ws_plugin__s2member_pro_authnet_ajax_tax_vars[zip]":R},function(U,W){clearTimeout(f),f=null;try{w.html("<div>"+y.sprintf('<strong>Sales Tax%s:</strong> %s<br /><strong>— Total%s:</strong> %s',((U.trial)?' Today':""),((U.tax_per)?"<em>"+U.tax_per+"</em> ( "+U.cur_symbol+""+U.tax+" )":U.cur_symbol+""+U.tax),((U.trial)?' Today':""),U.cur_symbol+""+U.total)+"</div>")}catch(V){}},"json")},((P&&P.keyCode)?1000:100))}else{if(!S||!T||!R||!Q){w.html(""),c=null}}}})();n=function(O){setTimeout(function(){G(O)},10)};y(F+" input#s2member-pro-authnet-checkout-state").bind("keyup blur",G).bind("cut paste",n);y(F+" input#s2member-pro-authnet-checkout-zip").bind("keyup blur",G).bind("cut paste",n);y(F+" select#s2member-pro-authnet-checkout-country").bind("change",G);setInterval(function(){G({interval:true})},1000);(q=function(O){if(y(m+" input#s2member-pro-authnet-checkout-password-not-required-or-not-possible").length){y(K+" > div#s2member-pro-authnet-checkout-form-password-div").hide();y(K+" > div#s2member-pro-authnet-checkout-form-password-div :input").attr(g)}})();(B=function(O){if(S2MEMBER_CURRENT_USER_IS_LOGGED_IN){y(K+" input#s2member-pro-authnet-checkout-first-name").each(function(){var P=y(this),Q=P.val();(!Q)?P.val(S2MEMBER_CURRENT_USER_FIRST_NAME):null});y(K+" input#s2member-pro-authnet-checkout-last-name").each(function(){var P=y(this),Q=P.val();(!Q)?P.val(S2MEMBER_CURRENT_USER_LAST_NAME):null});y(K+" input#s2member-pro-authnet-checkout-email").val(S2MEMBER_CURRENT_USER_EMAIL).attr(g);y(K+" input#s2member-pro-authnet-checkout-username").val(S2MEMBER_CURRENT_USER_LOGIN).attr(g);y(K+" > div#s2member-pro-authnet-checkout-form-password-div").hide();y(K+" > div#s2member-pro-authnet-checkout-form-password-div :input").attr(g);if(y.trim(y(K+" > div#s2member-pro-authnet-checkout-form-registration-section-title").html())==='Create Profile'){y(K+" > div#s2member-pro-authnet-checkout-form-registration-section-title").html('Your Profile')}y(N).hide(),y(N+" :input").attr(g)}})();(s=function(O){if(y(m+" input#s2member-pro-authnet-checkout-payment-not-required-or-not-possible").length){y(k).val(["Free"])}var P=y(k+":checked").val();if(y.inArray(P,["Free"])!==-1){y(t).hide(),y(F).hide();y(t+" > div.s2member-pro-authnet-checkout-form-div").hide();y(t+" > div.s2member-pro-authnet-checkout-form-div :input").attr(b);y(F+" > div.s2member-pro-authnet-checkout-form-div").hide();y(F+" > div.s2member-pro-authnet-checkout-form-div :input").attr(b);(!r)?w.hide():null;(O)?y(m+" button#s2member-pro-authnet-checkout-submit").focus():null}else{if(y.inArray(P,["Visa","MasterCard","Amex","Discover"])!==-1){y(t).show(),y(F).show();y(t+" > div.s2member-pro-authnet-checkout-form-div").show();y(t+" > div.s2member-pro-authnet-checkout-form-div :input").attr(v);y(t+" > div#s2member-pro-authnet-checkout-form-card-start-date-issue-number-div").hide();y(t+" > div#s2member-pro-authnet-checkout-form-card-start-date-issue-number-div :input").attr(b);y(F+" > div.s2member-pro-authnet-checkout-form-div").show();y(F+" > div.s2member-pro-authnet-checkout-form-div :input").attr(v);(!r)?w.hide():null;(O)?y(t+" input#s2member-pro-authnet-checkout-card-number").focus():null}else{if(y.inArray(P,["Maestro","Solo"])!==-1){y(t).show(),y(F).show();y(t+" > div.s2member-pro-authnet-checkout-form-div").show();y(t+" > div.s2member-pro-authnet-checkout-form-div :input").attr(v);y(F+" > div.s2member-pro-authnet-checkout-form-div").show();y(F+" > div.s2member-pro-authnet-checkout-form-div :input").attr(v);(!r)?w.hide():null;(O)?y(t+" input#s2member-pro-authnet-checkout-card-number").focus():null}else{if(!P){y(t).show(),y(F).hide();y(t+" > div.s2member-pro-authnet-checkout-form-div").hide();y(t+" > div.s2member-pro-authnet-checkout-form-div :input").attr(b);y(t+" > div#s2member-pro-authnet-checkout-form-card-type-div").show();y(t+" > div#s2member-pro-authnet-checkout-form-card-type-div :input").attr(v);y(F+" > div.s2member-pro-authnet-checkout-form-div").hide();y(F+" > div.s2member-pro-authnet-checkout-form-div :input").attr(b);(!r)?w.hide():null;(O)?y(m+" button#s2member-pro-authnet-checkout-submit").focus():null}}}}})();y(k).click(s).change(s);y(M).click(function(){y(j).val("apply-coupon"),o.submit()});y(K+" > div#s2member-pro-authnet-checkout-form-password-div :input").on("keyup initialize.s2",function(){ws_plugin__s2member_passwordStrength(y(K+" input#s2member-pro-authnet-checkout-username"),y(K+" input#s2member-pro-authnet-checkout-password1"),y(K+" input#s2member-pro-authnet-checkout-password2"),y(K+" div#s2member-pro-authnet-checkout-form-password-strength"))}).trigger("initialize.s2");o.submit(function(){if(y.inArray(y(j).val(),["option","apply-coupon"])===-1){var R=this,P="",O="",U="";var Q=y(L+" input#recaptcha_response_field, "+L+" #g-recaptcha-response");var T=y(K+' input#s2member-pro-authnet-checkout-password1[aria-required="true"]');var S=y(K+" input#s2member-pro-authnet-checkout-password2");if(!y(k+":checked").val()){alert('Please choose a Billing Method.');return false}y(":input",R).each(function(){var V=y.trim(y(this).attr("id")).replace(/---[0-9]+$/g,"");if(V&&(P=y.trim(y('label[for="'+V.replace(/-(month|year)/,"")+'"]',R).first().children("span").first().text().replace(/[\r\n\t]+/g," ")))){if(O=ws_plugin__s2member_validationErrors(P,this,R)){U+=O+"\n\n"}}});if(U=y.trim(U)){alert('— Oops, you missed something: —\n\n'+U);return false}else{if(T.length&&y.trim(T.val())!==y.trim(S.val())){alert('— Oops, you missed something: —\n\nPasswords do not match up. Please try again.');return false}else{if(T.length&&y.trim(T.val()).length<ws_plugin__s2member_passwordMinLength()){alert('— Oops, you missed something: —\n\nPassword MUST be at least 8 characters. Please try again.');return false}else{if(T.length&&ws_plugin__s2member_passwordStrengthMeter(y.trim(T.val()),y.trim(S.val()),true)<ws_plugin__s2member_passwordMinStrengthScore()){alert('— Oops, you missed something: —\n\nPassword strength MUST be `good` or `strong` (i.e., use numbers, letters, and mixed caSe). Please try again.');return false}else{if(Q.length&&!Q.val()){alert('— Oops, you missed something: —\n\nSecurity Verification missing. Please try again.');return false}}}}}}y(d).attr(z),ws_plugin__s2member_animateProcessing(y(d)),y(M).attr(z);return true})}}}}}(I=function(){y("div#s2member-pro-authnet-form-response").each(function(){var O=y(this).offset();window.scrollTo(0,O.top-100)})})()});
var S2MEMBER_PRO_CLICKBANK_GATEWAY = true;
jQuery(document).ready(function(a){});