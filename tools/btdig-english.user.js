// ==UserScript==
// @name         BTDig English UI
// @namespace    https://github.com/latenitekode
// @version      1.0.1
// @description  Restores an English BTDig interface without changing torrent titles, searches or magnet links.
// @author       latenitekode
// @match        *://btdig.com/*
// @match        *://www.btdig.com/*
// @match        *://en.btdig.com/*
// @connect      translate.googleapis.com
// @grant        GM_xmlhttpRequest
// @run-at       document-idle
// ==/UserScript==

(() => {
'use strict';
const H=/[\uac00-\ud7af]/, KEY='__btdig_en_v1', inflight=new Map();
const UI=/(검색|결과|관련|정렬|날짜|크기|파일|이전|다음|페이지|언어|한국어|영어|중국어|정보|연락|마그넷|링크|숨김|발견|찾음|초 전|분 전|시간 전|일 전|개월 전|년 전)/;
const BOX='button,label,legend,th,option,nav,header,footer,form,[role="button"],[role="menuitem"],[role="tab"],.pagination,.pager,.sorting,.sort,.filter,.language,.languages,.lang,.locale,.menu,.navbar,.header,.footer,.controls,.toolbar';
const SKIP='script,style,noscript,pre,code,textarea,[contenteditable="true"],a[href^="magnet:"]';
const D=new Map([['검색','Search'],['검색하기','Search'],['결과','Results'],['관련도','Relevance'],['날짜','Date'],['크기','Size'],['파일','Files'],['이전','Previous'],['다음','Next'],['언어','Language'],['한국어','Korean'],['영어','English'],['간체 중국어','Simplified Chinese'],['정보','About'],['연락처','Contacts'],['마그넷 링크','Magnet link'],['숨겨진 파일','Hidden files']]);
let C={}; try{C=JSON.parse(localStorage.getItem(KEY)||'{}')}catch{}
const norm=s=>(s||'').replace(/\s+/g,' ').trim();
const short=s=>{s=norm(s);return s&&s.length<=140&&H.test(s)};
function save(){try{const e=Object.entries(C);if(e.length>300)C=Object.fromEntries(e.slice(-300));localStorage.setItem(KEY,JSON.stringify(C))}catch{}}
function remote(t){return new Promise((ok,no)=>GM_xmlhttpRequest({method:'GET',url:'https://translate.googleapis.com/translate_a/single?client=gtx&sl=ko&tl=en&dt=t&q='+encodeURIComponent(t),timeout:12000,onload:r=>{try{if(r.status<200||r.status>=300)throw 0;const d=JSON.parse(r.responseText),x=(d[0]||[]).map(v=>v[0]||'').join('').trim();x?ok(x):no()}catch(e){no(e)}},onerror:no,ontimeout:no}))}
function tr(t){t=norm(t);if(!H.test(t))return Promise.resolve(t);if(D.has(t))return Promise.resolve(D.get(t));if(C[t])return Promise.resolve(C[t]);if(inflight.has(t))return inflight.get(t);const p=remote(t).then(x=>(C[t]=x,save(),x)).catch(()=>D.get(t)||t).finally(()=>inflight.delete(t));inflight.set(t,p);return p}
function safe(n){if(!n?.parentElement)return false;const p=n.parentElement,t=norm(n.nodeValue);if(!short(t)||p.closest(SKIP))return false;if(p.closest(BOX))return true;if(p.closest('a'))return false;return UI.test(t)}
async function text(n){if(!safe(n))return;const old=n.nodeValue,t=norm(old),x=await tr(t);if(!n.isConnected||x===t)return;const a=(old.match(/^\s*/)||[''])[0],b=(old.match(/\s*$/)||[''])[0];n.nodeValue=a+x+b}
async function attr(e,k){const v=e.getAttribute(k);if(!short(v))return;const x=await tr(v);if(e.isConnected)e.setAttribute(k,x)}
async function val(e){if(!['submit','button','reset'].includes((e.type||'').toLowerCase())||!short(e.value))return;const x=await tr(e.value);if(e.isConnected)e.value=x}
function scan(root=document){if(root.nodeType===3){text(root);return}const w=document.createTreeWalker(root,NodeFilter.SHOW_TEXT,{acceptNode:n=>safe(n)?1:2}),a=[];while(w.nextNode())a.push(w.currentNode);a.forEach(text);if(!root.querySelectorAll)return;root.querySelectorAll('[placeholder],[title],[aria-label]').forEach(e=>['placeholder','title','aria-label'].forEach(k=>attr(e,k)));root.querySelectorAll('input[type="submit"],input[type="button"],input[type="reset"]').forEach(val)}
function title(){const t=document.title;if(short(t))tr(t).then(x=>document.title=x)}
document.documentElement.lang='en';scan();title();let timer;new MutationObserver(ms=>{clearTimeout(timer);timer=setTimeout(()=>{for(const m of ms){if(m.type==='characterData')scan(m.target);for(const n of m.addedNodes)scan(n);if(m.type==='attributes')scan(m.target)}title()},80)}).observe(document.documentElement,{subtree:true,childList:true,characterData:true,attributes:true,attributeFilter:['placeholder','title','aria-label','value']});
})();
