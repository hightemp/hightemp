Напиши forward http proxy на golang

---

Ньюансы:
- метод CONNECT, нейросети его забывают
- tls для https
- ListenAndServeTLS метод не поддерживает Hijacking
