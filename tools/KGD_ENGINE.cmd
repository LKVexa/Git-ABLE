// 2>nul & @goto :kgd_engine_cmd
/*
:kgd_engine_cmd
@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem KGD_ENGINE.cmd - the engine of the LK/Vexa KGD-IMQ 5-Dollar LLM, .cmd edition. This one file is a Windows command
rem script and, below it, the engine's C# source. On first use the source is compiled with the C# compiler that comes
rem with Windows (.NET Framework 4, csc.exe), and the program is kept in
rem %LOCALAPPDATA%\LKVexa\kgd-imq-engine\<SHA-256 of this file>. Nothing is downloaded or installed.
rem Run it without arguments for the list of commands; the files in tools\ are short front ends to it.
set "KGD_SRC=%~f0"
set "KGD_CSC=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if not exist "%KGD_CSC%" goto :kgd_engine_nocsc
set "KGD_HASH="
for /f "skip=1 delims=" %%H in ('certutil -hashfile "%KGD_SRC%" SHA256') do if not defined KGD_HASH set "KGD_HASH=%%H"
if not defined KGD_HASH goto :kgd_engine_nohash
set "KGD_HASH=%KGD_HASH: =%"
set "KGD_BASE=%LOCALAPPDATA%"
if not defined KGD_BASE set "KGD_BASE=%TEMP%"
set "KGD_BIN=%KGD_BASE%\LKVexa\kgd-imq-engine\%KGD_HASH%"
if exist "%KGD_BIN%\kgd_engine.exe" goto :kgd_engine_run
if not exist "%KGD_BIN%" mkdir "%KGD_BIN%"
set "KGD_TMP=%KGD_BIN%\kgd_engine.%RANDOM%%RANDOM%.exe"
"%KGD_CSC%" /nologo /optimize+ /platform:x64 /target:exe /reference:System.Core.dll /out:"%KGD_TMP%" "%KGD_SRC%" > "%KGD_BIN%\compile.log" 2>&1
if errorlevel 1 goto :kgd_engine_compile_failed
move /y "%KGD_TMP%" "%KGD_BIN%\kgd_engine.exe" >nul 2>nul
if exist "%KGD_TMP%" del "%KGD_TMP%" >nul 2>nul
:kgd_engine_run
"%KGD_BIN%\kgd_engine.exe" %*
exit /b %errorlevel%
:kgd_engine_compile_failed
type "%KGD_BIN%\compile.log" 1>&2
echo KGD_ENGINE: the engine did not compile; the messages above are from csc.exe. 1>&2
if exist "%KGD_TMP%" del "%KGD_TMP%" >nul 2>nul
exit /b 3
:kgd_engine_nocsc
echo KGD_ENGINE: the C# compiler of .NET Framework 4 was not found at "%KGD_CSC%". 1>&2
exit /b 3
:kgd_engine_nohash
echo KGD_ENGINE: certutil could not hash this file. 1>&2
exit /b 3
*/
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;

namespace LKVexa.KgdEngine
{
    // ======== 00_main.cs ========
    public static class EntryPoint
    {
        const string Usage =
@"KGD_ENGINE.cmd - the LK/Vexa KGD-IMQ 5-Dollar LLM engine (.cmd edition). Commands:
  lb verify MANIFEST.cmd [--cap N] [--total-cap N] [--expect-set SHA512] [--bound] [--out FILE.cmd]
  lb combined COMBINED-MANIFEST.cmd [--cap N] [--total-cap N] [--out FILE.cmd]
  lb bound SHARD.cmd | lb decode SHARD.cmd
  gen model1 OUT_DIR [--seed 0]
  gen model2 OUT_DIR --d D --layers N [--seed 2026] [--split] [--probe]
  gen combined WEIGHTS_DIR
  data pack FILE OUT_DIR STEM LABEL | data unpack OUT_FILE SHARD.cmd...
  doc pack IN OUT.cmd NAME TYPE [--kind print|kgd-program|core-program] | doc extract IN.cmd OUT | doc check IN.cmd... | doc print IN.cmd
  host check|run PROGRAM.cmd [--twice]
  programs make PKG_DIR | programs run-all PKG_DIR EVIDENCE_DIR [--only A,B] [--skip A,B] [--core LCUF_X_DIR]
  check grad|factored SMALL_DIR|size-drift PKG_DIR|size-bound PKG_DIR TMP_DIR [--out FILE.cmd]
  package write PKG_DIR | package verify PKG_DIR
  hashes ROOT [--out FILE.cmd] | compare-hashes EXPECTED.cmd ROOT
  selftest EXPECTED.cmd [--out FILE.cmd]
  reason bayes|admit|meanfield|parity|witness|codelen SPEC [--out FILE.cmd] | reason selftest [--out FILE.cmd]
Exit code 0: done and every check passed; 1: a check failed; 2: refused or bad input; 3: internal error.";

        public static int Main(string[] argv)
        {
            Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;
            Thread.CurrentThread.CurrentUICulture = CultureInfo.InvariantCulture;
            try { Console.OutputEncoding = new UTF8Encoding(false); } catch (Exception) { }
            try { return Dispatch(argv); }
            catch (EngineError e) { Console.Error.WriteLine("KGD_ENGINE: " + e.Message); return 2; }
            catch (IOException e) { Console.Error.WriteLine("KGD_ENGINE: " + e.Message); return 2; }
            catch (UnauthorizedAccessException e) { Console.Error.WriteLine("KGD_ENGINE: " + e.Message); return 2; }
            catch (Exception e) { Console.Error.WriteLine("KGD_ENGINE: internal error: " + e); return 3; }
        }

        static void Print(object v) { Console.Out.Write(Json.Dump(v, 1, false)); Console.Out.Write("\n"); Console.Out.Flush(); }

        static int Emit(JObj res, Args a, string name, string passKey)
        {
            string outp = a.Opt("--out");
            if (outp != null) Doc.WriteJson(outp, name, res);
            Print(res);
            if (passKey == null) return 0;
            object p = res.Get(passKey);
            return (p is bool && (bool)p) ? 0 : 1;
        }

        static HashSet<string> Set(string csv) { return csv == null ? null : new HashSet<string>(csv.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries), StringComparer.Ordinal); }

        static int Dispatch(string[] argv)
        {
            if (argv.Length < 1 || argv[0] == "help" || argv[0] == "--help" || argv[0] == "/?") { Console.Out.WriteLine(Usage); return argv.Length < 1 ? 2 : 0; }
            string g = argv[0], c = argv.Length > 1 ? argv[1] : "";
            var vo = new[] { "--cap", "--total-cap", "--expect-set", "--out", "--seed", "--d", "--layers", "--only", "--skip", "--core", "--kind" };
            switch (g)
            {
                case "lb":
                    {
                        var a = new Args(argv, 2, vo);
                        if (c == "verify")
                            return Emit(Verify.CheckSet(a.At(0, "MANIFEST.cmd"), a.OptLong("--cap"), a.OptLong("--total-cap"), a.Opt("--expect-set"), a.Flag("--bound")), a, "verify.json", "all_pass");
                        if (c == "combined")
                            return Emit(Verify.CheckCombined(a.At(0, "COMBINED-MANIFEST.cmd"), a.OptLong("--cap"), a.OptLong("--total-cap")), a, "verify-combined.json", "all_pass");
                        if (c == "bound" || c == "decode")
                        {
                            var sd = ShardData.Read(a.At(0, "SHARD.cmd"), false, true);
                            var r = new JObj();
                            r["file"] = sd.Name; r["bytes"] = sd.Bytes; r["sha512"] = sd.FileSha512;
                            r["payload_sha512_ok"] = sd.PayloadShaOk; r["payload_lines_ok"] = sd.LinesOk; r["l1_ok"] = sd.L1Ok;
                            r["bytes_bound_any_values"] = sd.BoundAnyValues;
                            var head = new JObj();
                            foreach (var kv in sd.Head) head[kv.Key] = kv.Value;
                            r["header"] = head;
                            if (c == "decode")
                            {
                                var fams = new JObj();
                                foreach (string f in sd.FamOrder)
                                {
                                    var v = sd.Fam[f];
                                    fams[f] = new JObj().Set("words", (long)v.Length).Set("first", Json.Longs(v.Take(4).Select(x => (long)x)));
                                }
                                r["families"] = fams;
                                var sc = new JObj();
                                foreach (var kv in sd.Scal) sc[kv.Key] = kv.Value;
                                r["scalars"] = sc;
                            }
                            Print(r);
                            return sd.PayloadShaOk && sd.LinesOk && sd.L1Ok ? 0 : 1;
                        }
                        break;
                    }
                case "gen":
                    {
                        var a = new Args(argv, 2, vo);
                        if (c == "model1") { Print(Gen.Model1(a.At(0, "OUT_DIR"), a.OptLong("--seed") ?? 0)); return 0; }
                        if (c == "model2")
                        {
                            int d = (int)(a.OptLong("--d") ?? 52224), layers = (int)(a.OptLong("--layers") ?? 34);
                            long seed = a.OptLong("--seed") ?? 2026;
                            if (a.Flag("--probe"))
                            {
                                var cfg = Cfg.FromJson(Gen.Model2Config(d, layers));
                                Directory.CreateDirectory(a.At(0, "OUT_DIR"));
                                Print(Gen.Model2Layer(a.At(0, "OUT_DIR"), seed, cfg, 0, a.Flag("--split")).Cast<object>().ToList());
                                return 0;
                            }
                            Print(Gen.Model2(a.At(0, "OUT_DIR"), d, layers, seed, a.Flag("--split")));
                            return 0;
                        }
                        if (c == "combined") { Print(Gen.Combined(a.At(0, "WEIGHTS_DIR"))); return 0; }
                        break;
                    }
                case "data":
                    {
                        var a = new Args(argv, 2, vo);
                        if (c == "pack")
                        {
                            var recs = Gen.DataPack(a.At(0, "FILE"), a.At(1, "OUT_DIR"), a.At(2, "STEM"), a.At(3, "LABEL"));
                            Print(recs.Cast<object>().ToList());
                            return 0;
                        }
                        if (c == "unpack")
                        {
                            byte[] b = Gen.DataUnpack(a.Pos.Skip(1));
                            U.WriteBytes(a.At(0, "OUT_FILE"), b);
                            Print(new JObj().Set("file", Path.GetFileName(a.Pos[0])).Set("bytes", (long)b.Length).Set("sha512", U.Sha512Hex(b)));
                            return 0;
                        }
                        break;
                    }
                case "doc":
                    {
                        var a = new Args(argv, 2, vo);
                        if (c == "pack")
                        {
                            Doc.Write(a.At(1, "OUT.cmd"), a.At(2, "NAME"), a.At(3, "TYPE"), File.ReadAllBytes(a.At(0, "IN")), a.Opt("--kind") ?? Doc.KindPrint);
                            return 0;
                        }
                        if (c == "extract") { U.WriteBytes(a.At(1, "OUT"), Doc.Read(a.At(0, "IN.cmd"))); return 0; }
                        if (c == "print") { Console.Out.Write(Doc.ReadText(a.At(0, "IN.cmd"))); return 0; }
                        if (c == "check")
                        {
                            bool all = true;
                            foreach (string f in a.Pos)
                            {
                                var info = Doc.Inspect(File.ReadAllBytes(f));
                                Console.Out.WriteLine((info.Ok ? "ok   " : "FAIL ") + f + (info.Ok ? "" : ": " + info.Error));
                                all &= info.Ok;
                            }
                            return all ? 0 : 1;
                        }
                        break;
                    }
                case "host":
                    {
                        var a = new Args(argv, 2, vo);
                        if (c == "check" || c == "run")
                        {
                            var res = Host.Run(a.At(0, "PROGRAM.cmd"), c, a.Flag("--twice"));
                            Print(res);
                            string st = res.Str("status");
                            return (st == "host_research_pass" || st == "host_static_admission_pass") ? 0 : 2;
                        }
                        break;
                    }
                case "programs":
                    {
                        var a = new Args(argv, 2, vo);
                        if (c == "make") { Print(Programs.Make(a.At(0, "PKG_DIR"))); return 0; }
                        if (c == "run-all")
                        {
                            var res = Programs.RunAll(a.At(0, "PKG_DIR"), a.At(1, "EVIDENCE_DIR"), Set(a.Opt("--only")), Set(a.Opt("--skip")) ?? new HashSet<string>(), a.Opt("--core"));
                            Print(res);
                            return (bool)res["all_run_as_expected"] ? 0 : 1;
                        }
                        break;
                    }
                case "check":
                    {
                        var a = new Args(argv, 2, vo);
                        if (c == "grad") return Emit(Checks.Grad(), a, "grad_check.json", "pass");
                        if (c == "factored") return Emit(Checks.FactoredPath(a.At(0, "SMALL_DIR")), a, "validate-factored.json", "pass");
                        if (c == "size-drift") return Emit(Checks.SizeDrift(a.At(0, "PKG_DIR")), a, "size-drift.json", null);
                        if (c == "size-bound") return Emit(Checks.SizeBound(a.At(0, "PKG_DIR"), a.At(1, "TMP_DIR")), a, "size-bound-test.json", "bound_equals_worst_case");
                        break;
                    }
                case "package":
                    {
                        var a = new Args(argv, 2, vo);
                        if (c == "write")
                        {
                            string pkg = a.At(0, "PKG_DIR");
                            var comb = (JObj)Doc.ReadJson(Path.Combine(pkg, "weights", "COMBINED-MANIFEST.cmd"));
                            Print(Checks.PackageWrite(pkg, comb.Str("combined_sha512")));
                            return 0;
                        }
                        if (c == "verify") return Emit(Checks.PackageVerify(a.At(0, "PKG_DIR")), a, "package-verify.json", "pass");
                        break;
                    }
                case "hashes":
                    {
                        var a = new Args(argv, 1, vo);
                        string root = a.At(0, "ROOT");
                        var files = new List<object>();
                        foreach (string rel in Checks.Files(root))
                        {
                            string p = Path.Combine(root, rel.Replace('/', Path.DirectorySeparatorChar));
                            files.Add(new JObj().Set("path", rel).Set("bytes", new FileInfo(p).Length).Set("sha512", U.Sha512File(p)));
                        }
                        var res = new JObj().Set("files", files);
                        return Emit(res, a, "hashes.json", null);
                    }
                case "compare-hashes":
                    {
                        var a = new Args(argv, 1, vo);
                        var exp = (JObj)Doc.ReadJson(a.At(0, "EXPECTED.cmd"));
                        string root = a.At(1, "ROOT");
                        var same = new List<object>(); var diff = new List<object>(); var missing = new List<object>();
                        foreach (object o in exp.Arr("files"))
                        {
                            var e = (JObj)o;
                            string p = Path.Combine(root, e.Str("path").Replace('/', Path.DirectorySeparatorChar));
                            if (!File.Exists(p)) { missing.Add(e["path"]); continue; }
                            if (U.Sha512File(p) == e.Str("sha512")) same.Add(e["path"]); else diff.Add(e["path"]);
                        }
                        var res = new JObj().Set("same", (long)same.Count).Set("different", diff).Set("missing", missing).Set("pass", diff.Count == 0 && missing.Count == 0);
                        return Emit(res, a, "compare.json", "pass");
                    }
                case "reason":
                    {
                        var a = new Args(argv, 2, vo);
                        if (c == "selftest") return Emit(Rails.SelfTest(), a, "rails-selftest.json", "all_pass");
                        string specPath = a.At(0, "SPEC");
                        var spec = Rails.ReadSpec(specPath);
                        string baseDir = Path.GetDirectoryName(Path.GetFullPath(specPath));
                        JObj res = null;
                        if (c == "bayes") res = Rails.Bayes(spec);
                        else if (c == "admit") res = Rails.Admit(spec);
                        else if (c == "meanfield") res = Rails.MeanField(spec);
                        else if (c == "parity")
                        {
                            var vals = spec.Get("values") as List<object>;
                            if (vals == null || vals.Count != 3 || vals.Any(x => !Json.IsNumber(x))) throw new EngineError("reason parity: the spec needs values, a list of three numbers");
                            res = Rails.Parity(spec, Json.ToDouble(vals[0]), Json.ToDouble(vals[1]), Json.ToDouble(vals[2]));
                        }
                        else if (c == "witness" || c == "codelen")
                        {
                            JObj about;
                            object w = Rails.LoadWitness(spec.Get("witness") as JObj, baseDir, out about);
                            res = c == "witness" ? Rails.Witness(w, about, spec) : Rails.CodeLen(w, about, spec.Get("text") as string);
                        }
                        if (res == null) break;
                        return Emit(res, a, "rails-" + c + ".json", null);
                    }
                case "selftest":
                    {
                        var a = new Args(argv, 1, vo);
                        var res = Checks.SelfTest((JObj)Doc.ReadJson(a.At(0, "EXPECTED.cmd")));
                        return Emit(res, a, "selftest.json", "all_pass");
                    }
            }
            Console.Error.WriteLine("KGD_ENGINE: unknown command: " + string.Join(" ", argv.Take(2)));
            Console.Error.WriteLine(Usage);
            return 2;
        }
    }

    // ======== 01_util.cs ========
    public class EngineError : Exception
    {
        public EngineError(string message) : base(message) { }
    }

    /// <summary>Hashing, number formatting (Python-compatible repr) and small file helpers.</summary>
    public static class U
    {
        public static readonly CultureInfo Inv = CultureInfo.InvariantCulture;
        public static readonly Encoding Utf8 = new UTF8Encoding(false);
        public static readonly Encoding Utf8Strict = new UTF8Encoding(false, true);
        public static readonly Encoding Ascii = Encoding.ASCII;
        public const string CRLF = "\r\n";

        public static HashAlgorithm NewSha512()
        {
            try { return new SHA512CryptoServiceProvider(); }
            catch (Exception) { return new SHA512Managed(); }
        }

        public static string Hex(byte[] h)
        {
            var sb = new StringBuilder(h.Length * 2);
            foreach (byte b in h) sb.Append(b.ToString("x2", Inv));
            return sb.ToString();
        }

        public static string Sha512Hex(byte[] data) { return Sha512Hex(data, 0, data.Length); }

        public static string Sha512Hex(byte[] data, int off, int len)
        {
            using (var s = NewSha512()) return Hex(s.ComputeHash(data, off, len));
        }

        public static string Sha512Text(string s) { return Sha512Hex(Utf8.GetBytes(s)); }

        public static string Sha512File(string path)
        {
            using (var s = NewSha512())
            using (var f = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.Read, 1 << 20))
                return Hex(s.ComputeHash(f));
        }

        public static byte[] Sha512Raw(byte[] data)
        {
            using (var s = NewSha512()) return s.ComputeHash(data);
        }

        public static string L(long v) { return v.ToString(Inv); }

        /// <summary>Python's repr(float): the shortest digits that read back to the same double, in Python's layout.</summary>
        public static string PyRepr(double x)
        {
            if (double.IsNaN(x)) return "nan";
            if (double.IsPositiveInfinity(x)) return "inf";
            if (double.IsNegativeInfinity(x)) return "-inf";
            if (x == 0.0) return (1.0 / x < 0) ? "-0.0" : "0.0";
            bool neg = x < 0;
            double a = Math.Abs(x);
            string digits = null;
            int decpt = 0;
            for (int p = 1; p <= 17; p++)
            {
                string s = a.ToString("E" + (p - 1).ToString(Inv), Inv);
                double back;
                if (!double.TryParse(s, NumberStyles.Float, Inv, out back) || back != a) continue;
                int e = s.IndexOf('E');
                string mant = s.Substring(0, e).Replace(".", "");
                int exp = int.Parse(s.Substring(e + 1), NumberStyles.AllowLeadingSign, Inv);
                digits = mant.TrimEnd('0');
                if (digits.Length == 0) digits = "0";
                decpt = exp + 1;
                break;
            }
            if (digits == null)
            {
                string r = a.ToString("R", Inv);
                return (neg ? "-" : "") + r.Replace("E+", "e+").Replace("E-", "e-");
            }
            var sb = new StringBuilder();
            if (neg) sb.Append('-');
            if (decpt <= -4 || decpt > 16)
            {
                sb.Append(digits[0]);
                if (digits.Length > 1) { sb.Append('.'); sb.Append(digits.Substring(1)); }
                int ex = decpt - 1;
                sb.Append('e');
                sb.Append(ex < 0 ? '-' : '+');
                sb.Append(Math.Abs(ex).ToString("00", Inv));
            }
            else if (decpt <= 0)
            {
                sb.Append("0.");
                sb.Append('0', -decpt);
                sb.Append(digits);
            }
            else if (decpt >= digits.Length)
            {
                sb.Append(digits);
                sb.Append('0', decpt - digits.Length);
                sb.Append(".0");
            }
            else
            {
                sb.Append(digits.Substring(0, decpt));
                sb.Append('.');
                sb.Append(digits.Substring(decpt));
            }
            return sb.ToString();
        }

        public static bool IsFinite(double v) { return !double.IsNaN(v) && !double.IsInfinity(v); }

        public static double RoundHalfEven(double v) { return Math.Round(v, MidpointRounding.ToEven); }

        public static void WriteBytes(string path, byte[] data)
        {
            string dir = Path.GetDirectoryName(Path.GetFullPath(path));
            if (!string.IsNullOrEmpty(dir)) Directory.CreateDirectory(dir);
            File.WriteAllBytes(path, data);
        }

        public static void WriteText(string path, string text) { WriteBytes(path, Utf8.GetBytes(text)); }

        public static int IndexOf(byte[] hay, byte[] needle, int start)
        {
            if (needle.Length == 0) return start;
            byte first = needle[0];
            int last = hay.Length - needle.Length;
            for (int i = start; i <= last; i++)
            {
                if (hay[i] != first) continue;
                int k = 1;
                while (k < needle.Length && hay[i + k] == needle[k]) k++;
                if (k == needle.Length) return i;
            }
            return -1;
        }

        /// <summary>Relative path from a folder to a file, with forward slashes (for records that must not hold machine paths).</summary>
        public static string Rel(string baseDir, string path)
        {
            string b = Path.GetFullPath(baseDir).TrimEnd('\\', '/') + Path.DirectorySeparatorChar;
            string p = Path.GetFullPath(path);
            if (p.StartsWith(b, StringComparison.OrdinalIgnoreCase)) return p.Substring(b.Length).Replace('\\', '/');
            return Path.GetFileName(p);
        }

        public static string Sci(double seconds) { return Math.Round(seconds, 1).ToString("0.0", Inv); }
    }

    /// <summary>JSON values as plain objects: null, bool, long, double, string, List&lt;object&gt;, JObj (insertion ordered).</summary>
    public class JObj
    {
        public readonly List<string> Keys = new List<string>();
        readonly Dictionary<string, object> map = new Dictionary<string, object>(StringComparer.Ordinal);

        public object this[string key]
        {
            get
            {
                object v;
                if (!map.TryGetValue(key, out v)) throw new EngineError("missing key " + key);
                return v;
            }
            set
            {
                if (!map.ContainsKey(key)) Keys.Add(key);
                map[key] = value;
            }
        }

        public bool Has(string key) { return map.ContainsKey(key); }
        public object Get(string key) { object v; return map.TryGetValue(key, out v) ? v : null; }
        public int Count { get { return Keys.Count; } }
        public JObj Set(string key, object value) { this[key] = value; return this; }

        public void Remove(string key)
        {
            if (map.Remove(key)) Keys.Remove(key);
        }

        public string Str(string key) { return (string)this[key]; }
        public long Long(string key) { return Json.ToLong(this[key]); }
        public double Dbl(string key) { return Json.ToDouble(this[key]); }
        public JObj Obj(string key) { return (JObj)this[key]; }
        public List<object> Arr(string key) { return (List<object>)this[key]; }
    }

    public static class Json
    {
        public static long ToLong(object v)
        {
            if (v is long) return (long)v;
            if (v is int) return (int)v;
            if (v is double) return (long)(double)v;
            if (v is bool) return ((bool)v) ? 1 : 0;
            throw new EngineError("not an integer");
        }

        public static double ToDouble(object v)
        {
            if (v is double) return (double)v;
            if (v is long) return (long)v;
            if (v is int) return (int)v;
            if (v is bool) return ((bool)v) ? 1 : 0;
            throw new EngineError("not a number");
        }

        public static bool IsNumber(object v) { return v is long || v is double || v is int; }

        // ---------------- parsing ----------------
        public static object Parse(string s)
        {
            int i = 0;
            object v = Value(s, ref i);
            Ws(s, ref i);
            if (i != s.Length) throw new EngineError("JSON: trailing characters");
            return v;
        }

        static void Ws(string s, ref int i)
        {
            while (i < s.Length && (s[i] == ' ' || s[i] == '\t' || s[i] == '\n' || s[i] == '\r')) i++;
        }

        static object Value(string s, ref int i)
        {
            Ws(s, ref i);
            if (i >= s.Length) throw new EngineError("JSON: unexpected end");
            char c = s[i];
            if (c == '{')
            {
                var o = new JObj();
                i++;
                Ws(s, ref i);
                if (i < s.Length && s[i] == '}') { i++; return o; }
                while (true)
                {
                    Ws(s, ref i);
                    if (i >= s.Length || s[i] != '"') throw new EngineError("JSON: key expected");
                    string k = Str(s, ref i);
                    Ws(s, ref i);
                    if (i >= s.Length || s[i] != ':') throw new EngineError("JSON: ':' expected");
                    i++;
                    o[k] = Value(s, ref i);
                    Ws(s, ref i);
                    if (i < s.Length && s[i] == ',') { i++; continue; }
                    if (i < s.Length && s[i] == '}') { i++; return o; }
                    throw new EngineError("JSON: ',' or '}' expected");
                }
            }
            if (c == '[')
            {
                var a = new List<object>();
                i++;
                Ws(s, ref i);
                if (i < s.Length && s[i] == ']') { i++; return a; }
                while (true)
                {
                    a.Add(Value(s, ref i));
                    Ws(s, ref i);
                    if (i < s.Length && s[i] == ',') { i++; continue; }
                    if (i < s.Length && s[i] == ']') { i++; return a; }
                    throw new EngineError("JSON: ',' or ']' expected");
                }
            }
            if (c == '"') return Str(s, ref i);
            if (string.CompareOrdinal(s, i, "true", 0, 4) == 0) { i += 4; return true; }
            if (string.CompareOrdinal(s, i, "false", 0, 5) == 0) { i += 5; return false; }
            if (string.CompareOrdinal(s, i, "null", 0, 4) == 0) { i += 4; return null; }
            if (string.CompareOrdinal(s, i, "NaN", 0, 3) == 0) { i += 3; return double.NaN; }
            if (string.CompareOrdinal(s, i, "Infinity", 0, 8) == 0) { i += 8; return double.PositiveInfinity; }
            if (string.CompareOrdinal(s, i, "-Infinity", 0, 9) == 0) { i += 9; return double.NegativeInfinity; }
            int j = i;
            bool isFloat = false;
            if (j < s.Length && (s[j] == '-' || s[j] == '+')) j++;
            while (j < s.Length)
            {
                char d = s[j];
                if (d >= '0' && d <= '9') { j++; continue; }
                if (d == '.' || d == 'e' || d == 'E' || d == '+' || d == '-') { isFloat = true; j++; continue; }
                break;
            }
            if (j == i) throw new EngineError("JSON: unexpected character '" + c + "'");
            string tok = s.Substring(i, j - i);
            i = j;
            if (!isFloat)
            {
                long lv;
                if (long.TryParse(tok, NumberStyles.AllowLeadingSign, U.Inv, out lv)) return lv;
            }
            double dv = double.Parse(tok, NumberStyles.Float, U.Inv);
            if (dv == 0 && tok.StartsWith("-", StringComparison.Ordinal)) dv = NegZero;
            return dv;
        }

        static readonly double NegZero = BitConverter.Int64BitsToDouble(unchecked((long)0x8000000000000000UL));

        static string Str(string s, ref int i)
        {
            i++;
            var sb = new StringBuilder();
            while (true)
            {
                if (i >= s.Length) throw new EngineError("JSON: unterminated string");
                char c = s[i++];
                if (c == '"') return sb.ToString();
                if (c != '\\') { sb.Append(c); continue; }
                char e = s[i++];
                switch (e)
                {
                    case '"': sb.Append('"'); break;
                    case '\\': sb.Append('\\'); break;
                    case '/': sb.Append('/'); break;
                    case 'b': sb.Append('\b'); break;
                    case 'f': sb.Append('\f'); break;
                    case 'n': sb.Append('\n'); break;
                    case 'r': sb.Append('\r'); break;
                    case 't': sb.Append('\t'); break;
                    case 'u':
                        sb.Append((char)int.Parse(s.Substring(i, 4), NumberStyles.HexNumber, U.Inv));
                        i += 4;
                        break;
                    default: throw new EngineError("JSON: bad escape");
                }
            }
        }

        // ---------------- writing (Python's json module layouts) ----------------
        public static string Quote(string s, bool ensureAscii)
        {
            var sb = new StringBuilder(s.Length + 2);
            sb.Append('"');
            foreach (char c in s)
            {
                switch (c)
                {
                    case '"': sb.Append("\\\""); break;
                    case '\\': sb.Append("\\\\"); break;
                    case '\n': sb.Append("\\n"); break;
                    case '\r': sb.Append("\\r"); break;
                    case '\t': sb.Append("\\t"); break;
                    case '\b': sb.Append("\\b"); break;
                    case '\f': sb.Append("\\f"); break;
                    default:
                        if (c < 0x20 || (ensureAscii && c > 0x7e))
                            sb.Append("\\u").Append(((int)c).ToString("x4", U.Inv));
                        else
                            sb.Append(c);
                        break;
                }
            }
            sb.Append('"');
            return sb.ToString();
        }

        static string Num(object v, bool allowNan)
        {
            if (v is long) return ((long)v).ToString(U.Inv);
            if (v is int) return ((int)v).ToString(U.Inv);
            double d = (double)v;
            if (double.IsNaN(d)) { if (!allowNan) throw new EngineError("JSON: NaN is not allowed here"); return "NaN"; }
            if (double.IsPositiveInfinity(d)) { if (!allowNan) throw new EngineError("JSON: Infinity is not allowed here"); return "Infinity"; }
            if (double.IsNegativeInfinity(d)) { if (!allowNan) throw new EngineError("JSON: Infinity is not allowed here"); return "-Infinity"; }
            return U.PyRepr(d);
        }

        /// <summary>json.dumps(v, indent=indent, ensure_ascii=ensureAscii) (indent less than 0: one line with ', ' and ': ').</summary>
        public static string Dump(object v, int indent, bool ensureAscii)
        {
            var sb = new StringBuilder();
            DumpTo(sb, v, indent, 0, ensureAscii);
            return sb.ToString();
        }

        static void DumpTo(StringBuilder sb, object v, int indent, int level, bool ea)
        {
            if (v == null) { sb.Append("null"); return; }
            if (v is bool) { sb.Append((bool)v ? "true" : "false"); return; }
            if (v is string) { sb.Append(Quote((string)v, ea)); return; }
            if (IsNumber(v)) { sb.Append(Num(v, true)); return; }
            var o = v as JObj;
            if (o != null)
            {
                if (o.Count == 0) { sb.Append("{}"); return; }
                sb.Append('{');
                for (int k = 0; k < o.Keys.Count; k++)
                {
                    if (k > 0) sb.Append(indent >= 0 ? "," : ", ");
                    if (indent >= 0) { sb.Append('\n'); sb.Append(' ', indent * (level + 1)); }
                    sb.Append(Quote(o.Keys[k], ea)).Append(": ");
                    DumpTo(sb, o[o.Keys[k]], indent, level + 1, ea);
                }
                if (indent >= 0) { sb.Append('\n'); sb.Append(' ', indent * level); }
                sb.Append('}');
                return;
            }
            var a = v as System.Collections.IList;
            if (a != null)
            {
                if (a.Count == 0) { sb.Append("[]"); return; }
                sb.Append('[');
                for (int k = 0; k < a.Count; k++)
                {
                    if (k > 0) sb.Append(indent >= 0 ? "," : ", ");
                    if (indent >= 0) { sb.Append('\n'); sb.Append(' ', indent * (level + 1)); }
                    DumpTo(sb, a[k], indent, level + 1, ea);
                }
                if (indent >= 0) { sb.Append('\n'); sb.Append(' ', indent * level); }
                sb.Append(']');
                return;
            }
            throw new EngineError("JSON: cannot write " + v.GetType().Name);
        }

        /// <summary>json.dumps(v, sort_keys=True, separators=(",", ":"), ensure_ascii=False, allow_nan=False).</summary>
        public static string Canonical(object v)
        {
            var sb = new StringBuilder();
            CanonTo(sb, v);
            return sb.ToString();
        }

        static void CanonTo(StringBuilder sb, object v)
        {
            if (v == null) { sb.Append("null"); return; }
            if (v is bool) { sb.Append((bool)v ? "true" : "false"); return; }
            if (v is string) { sb.Append(Quote((string)v, false)); return; }
            if (IsNumber(v)) { sb.Append(Num(v, false)); return; }
            var o = v as JObj;
            if (o != null)
            {
                var keys = new List<string>(o.Keys);
                keys.Sort(string.CompareOrdinal);
                sb.Append('{');
                for (int k = 0; k < keys.Count; k++)
                {
                    if (k > 0) sb.Append(',');
                    sb.Append(Quote(keys[k], false)).Append(':');
                    CanonTo(sb, o[keys[k]]);
                }
                sb.Append('}');
                return;
            }
            var a = v as System.Collections.IList;
            if (a != null)
            {
                sb.Append('[');
                for (int k = 0; k < a.Count; k++)
                {
                    if (k > 0) sb.Append(',');
                    CanonTo(sb, a[k]);
                }
                sb.Append(']');
                return;
            }
            throw new EngineError("JSON: cannot write " + v.GetType().Name);
        }

        /// <summary>Python's == between JSON values (1 == 1.0, True == 1).</summary>
        public static bool PyEquals(object a, object b)
        {
            if (a == null || b == null) return a == null && b == null;
            bool an = IsNumber(a) || a is bool, bn = IsNumber(b) || b is bool;
            if (an && bn)
            {
                if ((a is long || a is int || a is bool) && (b is long || b is int || b is bool)) return ToLong(a) == ToLong(b);
                return ToDouble(a) == ToDouble(b);
            }
            if (a is string && b is string) return string.Equals((string)a, (string)b, StringComparison.Ordinal);
            var la = a as List<object>;
            var lb = b as List<object>;
            if (la != null && lb != null)
            {
                if (la.Count != lb.Count) return false;
                for (int i = 0; i < la.Count; i++) if (!PyEquals(la[i], lb[i])) return false;
                return true;
            }
            var oa = a as JObj;
            var ob = b as JObj;
            if (oa != null && ob != null)
            {
                if (oa.Count != ob.Count) return false;
                foreach (string k in oa.Keys) if (!ob.Has(k) || !PyEquals(oa[k], ob[k])) return false;
                return true;
            }
            return false;
        }

        public static List<object> List(params object[] items) { return new List<object>(items); }

        public static List<object> Longs(IEnumerable<long> v) { var l = new List<object>(); foreach (long x in v) l.Add(x); return l; }
    }

    /// <summary>Command-line options: positional arguments and --name value / --flag.</summary>
    public class Args
    {
        public readonly List<string> Pos = new List<string>();
        readonly Dictionary<string, string> opt = new Dictionary<string, string>(StringComparer.Ordinal);
        readonly HashSet<string> flags = new HashSet<string>(StringComparer.Ordinal);

        public Args(string[] a, int start, params string[] valueOptions)
        {
            var takes = new HashSet<string>(valueOptions, StringComparer.Ordinal);
            for (int i = start; i < a.Length; i++)
            {
                if (a[i].StartsWith("--", StringComparison.Ordinal))
                {
                    if (takes.Contains(a[i]))
                    {
                        if (i + 1 >= a.Length) throw new EngineError(a[i] + " needs a value");
                        opt[a[i]] = a[++i];
                    }
                    else flags.Add(a[i]);
                }
                else Pos.Add(a[i]);
            }
        }

        public bool Flag(string name) { return flags.Contains(name); }
        public string Opt(string name) { string v; return opt.TryGetValue(name, out v) ? v : null; }
        public long? OptLong(string name)
        {
            string v = Opt(name);
            if (v == null) return null;
            return long.Parse(v, NumberStyles.AllowLeadingSign, U.Inv);
        }
        public string At(int i, string what)
        {
            if (i >= Pos.Count) throw new EngineError("missing argument: " + what);
            return Pos[i];
        }
    }

    // ======== 02_rng.cs ========
    /// <summary>
    /// numpy-compatible random numbers: SeedSequence (pool size 4), PCG64 (XSL-RR 128/64), next_uint32 with its
    /// one-word buffer, next_double, Lemire bounded integers and the ziggurat standard normal. Every value equals
    /// numpy 2.x's np.random.Generator(np.random.PCG64(seed)) for the calls the package makes.
    /// </summary>
    public sealed class Pcg64
    {
        const ulong MH = 0x2360ED051FC65DA4UL, ML = 0x4385DF649FCCF645UL;
        ulong sHi, sLo, iHi, iLo;
        bool has32;
        uint u32;

        public static Pcg64 FromText(string seedText)
        {
            byte[] h = U.Sha512Raw(U.Utf8.GetBytes(seedText));
            var w = new uint[4];
            for (int k = 0; k < 4; k++) w[k] = BitConverter.ToUInt32(h, 4 * k);
            return new Pcg64(w);
        }

        public static Pcg64 FromSeed(long seed)
        {
            if (seed < 0) throw new EngineError("negative seed");
            return new Pcg64(new uint[] { (uint)((ulong)seed & 0xFFFFFFFFUL), (uint)((ulong)seed >> 32), 0, 0 });
        }

        public Pcg64(uint[] entropy)
        {
            uint[] pool = Pool(entropy);
            ulong[] v = Generate64(pool, 4);
            ulong stHi = v[0], stLo = v[1];
            iHi = (v[2] << 1) | (v[3] >> 63);
            iLo = (v[3] << 1) | 1UL;
            sHi = 0; sLo = 0;
            Step();
            ulong lo = sLo + stLo;
            ulong carry = lo < sLo ? 1UL : 0UL;
            sLo = lo;
            sHi = sHi + stHi + carry;
            Step();
        }

        static uint HashMix(uint value, ref uint hc)
        {
            value ^= hc;
            hc = unchecked(hc * 0x931e8875u);
            value = unchecked(value * hc);
            value ^= value >> 16;
            return value;
        }

        static uint Mix(uint x, uint y)
        {
            uint r = unchecked(0xca01f9ddu * x - 0x4973f715u * y);
            r ^= r >> 16;
            return r;
        }

        static uint[] Pool(uint[] ent)
        {
            uint hc = 0x43b0d7e5u;
            var m = new uint[4];
            for (int i = 0; i < 4; i++) m[i] = HashMix(i < ent.Length ? ent[i] : 0u, ref hc);
            for (int s = 0; s < 4; s++)
                for (int d = 0; d < 4; d++)
                    if (s != d) m[d] = Mix(m[d], HashMix(m[s], ref hc));
            for (int s = 4; s < ent.Length; s++)
                for (int d = 0; d < 4; d++) m[d] = Mix(m[d], HashMix(ent[s], ref hc));
            return m;
        }

        static ulong[] Generate64(uint[] pool, int n64)
        {
            uint hc = 0x8b51f9ddu;
            var w = new uint[2 * n64];
            for (int i = 0; i < w.Length; i++)
            {
                uint v = pool[i % pool.Length];
                v ^= hc;
                hc = unchecked(hc * 0x58f38dedu);
                v = unchecked(v * hc);
                v ^= v >> 16;
                w[i] = v;
            }
            var o = new ulong[n64];
            for (int k = 0; k < n64; k++) o[k] = w[2 * k] | ((ulong)w[2 * k + 1] << 32);
            return o;
        }

        static void Mul64(ulong a, ulong b, out ulong hi, out ulong lo)
        {
            ulong aL = a & 0xFFFFFFFFUL, aH = a >> 32, bL = b & 0xFFFFFFFFUL, bH = b >> 32;
            ulong ll = aL * bL, lh = aL * bH, hl = aH * bL, hh = aH * bH;
            ulong mid = (ll >> 32) + (lh & 0xFFFFFFFFUL) + (hl & 0xFFFFFFFFUL);
            lo = (ll & 0xFFFFFFFFUL) | (mid << 32);
            hi = hh + (lh >> 32) + (hl >> 32) + (mid >> 32);
        }

        void Step()
        {
            ulong hi, lo;
            Mul64(sLo, ML, out hi, out lo);
            hi = unchecked(hi + sHi * ML + sLo * MH);
            ulong nlo = unchecked(lo + iLo);
            ulong carry = nlo < lo ? 1UL : 0UL;
            sLo = nlo;
            sHi = unchecked(hi + iHi + carry);
        }

        public ulong Next64()
        {
            Step();
            ulong x = sHi ^ sLo;
            int r = (int)(sHi >> 58);
            return (x >> r) | (x << ((64 - r) & 63));
        }

        public uint Next32()
        {
            if (has32) { has32 = false; return u32; }
            ulong n = Next64();
            has32 = true;
            u32 = (uint)(n >> 32);
            return (uint)(n & 0xFFFFFFFFUL);
        }

        public double NextDouble() { return (Next64() >> 11) * (1.0 / 9007199254740992.0); }

        uint Lemire32(uint rng)
        {
            uint excl = rng + 1;
            ulong m = (ulong)Next32() * excl;
            uint left = (uint)m;
            if (left < excl)
            {
                uint thr = (0xFFFFFFFFu - rng) % excl;
                while (left < thr)
                {
                    m = (ulong)Next32() * excl;
                    left = (uint)m;
                }
            }
            return (uint)(m >> 32);
        }

        /// <summary>Generator.integers(low, high, dtype=int64) for one value; high - low is at most 2^32.</summary>
        public long Integer(long low, long high)
        {
            ulong rng = (ulong)(high - 1 - low);
            if (rng == 0) return low;
            if (rng == 0xFFFFFFFFUL) return low + Next32();
            if (rng < 0xFFFFFFFFUL) return low + Lemire32((uint)rng);
            throw new EngineError("integer range above 2^32 is not supported");
        }

        public long[] Integers(long low, long high, int n)
        {
            var o = new long[n];
            for (int i = 0; i < n; i++) o[i] = Integer(low, high);
            return o;
        }

        public double StandardNormal() { return Zig.Normal(this); }

        public double Uniform(double low, double high) { return low + (high - low) * NextDouble(); }
    }

    static partial class Zig
    {
        static readonly double[] WI, FI;
        static readonly double R, INV_R;

        // a static constructor runs after the field initializers of every part of the class, so the tables exist here
        static Zig()
        {
            WI = Bits(WI_BITS);
            FI = Bits(FI_BITS);
            R = BitConverter.Int64BitsToDouble((long)R_BITS);
            INV_R = BitConverter.Int64BitsToDouble((long)INV_R_BITS);
        }

        static double[] Bits(ulong[] b)
        {
            var d = new double[b.Length];
            for (int i = 0; i < b.Length; i++) d[i] = BitConverter.Int64BitsToDouble((long)b[i]);
            return d;
        }

        /// <summary>numpy's random_standard_normal (distributions.c), step for step.</summary>
        internal static double Normal(Pcg64 g)
        {
            while (true)
            {
                ulong r = g.Next64();
                int idx = (int)(r & 0xff);
                r >>= 8;
                ulong sign = r & 1UL;
                ulong rabs = (r >> 1) & 0x000fffffffffffffUL;
                double x = rabs * WI[idx];
                if (sign != 0) x = -x;
                if (rabs < KI[idx]) return x;
                if (idx == 0)
                {
                    while (true)
                    {
                        double xx = -INV_R * FdLibm.Log1p(-g.NextDouble());
                        double yy = -FdLibm.Log1p(-g.NextDouble());
                        if (yy + yy > xx * xx)
                            return ((rabs >> 8) & 1UL) != 0 ? -(R + xx) : R + xx;
                    }
                }
                if (((FI[idx - 1] - FI[idx]) * g.NextDouble() + FI[idx]) < Math.Exp(-0.5 * x * x)) return x;
            }
        }
    }

    /// <summary>fdlibm's log1p (s_log1p.c), which only uses IEEE-754 basic operations, so it gives the same bits everywhere.</summary>
    public static class FdLibm
    {
        const double ln2_hi = 6.93147180369123816490e-01, ln2_lo = 1.90821492927058770002e-10, two54 = 1.80143985094819840000e+16;
        const double Lp1 = 6.666666666666735130e-01, Lp2 = 3.999999999940941908e-01, Lp3 = 2.857142874366239149e-01,
                     Lp4 = 2.222219843214978396e-01, Lp5 = 1.818357216161805012e-01, Lp6 = 1.531383769920937332e-01,
                     Lp7 = 1.479819860511658591e-01;

        static int Hi(double x) { return (int)(BitConverter.DoubleToInt64Bits(x) >> 32); }

        static double WithHi(double x, int hi)
        {
            long b = BitConverter.DoubleToInt64Bits(x);
            b = ((long)hi << 32) | (b & 0xFFFFFFFFL);
            return BitConverter.Int64BitsToDouble(b);
        }

        public static double Log1p(double x)
        {
            int hx = Hi(x);
            int ax = hx & 0x7fffffff;
            int k = 1, hu = 0;
            double f = 0.0, c = 0.0, u;
            if (hx < 0x3FDA827A)
            {
                if (ax >= 0x3ff00000)
                {
                    if (x == -1.0) return double.NegativeInfinity;
                    return double.NaN;
                }
                if (ax < 0x3e200000)
                {
                    if (two54 + x > 0.0 && ax < 0x3c900000) return x;
                    return x - x * x * 0.5;
                }
                if (hx > 0 || hx <= unchecked((int)0xbfd2bec3)) { k = 0; f = x; hu = 1; }
            }
            if (hx >= 0x7ff00000) return x + x;
            if (k != 0)
            {
                if (hx < 0x43400000)
                {
                    u = 1.0 + x;
                    hu = Hi(u);
                    k = (hu >> 20) - 1023;
                    c = (k > 0) ? 1.0 - (u - x) : x - (u - 1.0);
                    c /= u;
                }
                else
                {
                    u = x;
                    hu = Hi(u);
                    k = (hu >> 20) - 1023;
                    c = 0;
                }
                hu &= 0x000fffff;
                if (hu < 0x6a09e)
                {
                    u = WithHi(u, hu | 0x3ff00000);
                }
                else
                {
                    k += 1;
                    u = WithHi(u, hu | 0x3fe00000);
                    hu = (0x00100000 - hu) >> 2;
                }
                f = u - 1.0;
            }
            double hfsq = 0.5 * f * f;
            if (hu == 0)
            {
                if (f == 0.0)
                {
                    if (k == 0) return 0.0;
                    c += k * ln2_lo;
                    return k * ln2_hi + c;
                }
                double Rr = hfsq * (1.0 - 0.66666666666666666 * f);
                if (k == 0) return f - Rr;
                return k * ln2_hi - ((Rr - (k * ln2_lo + c)) - f);
            }
            double s = f / (2.0 + f);
            double z = s * s;
            double R = z * (Lp1 + z * (Lp2 + z * (Lp3 + z * (Lp4 + z * (Lp5 + z * (Lp6 + z * Lp7))))));
            if (k == 0) return f - (hfsq - s * (hfsq + R));
            return k * ln2_hi - ((hfsq - (s * (hfsq + R) + (k * ln2_lo + c))) - f);
        }

        public static double Expm1(double x)
        {
            if (Math.Abs(x) < 1e-5) return x + 0.5 * x * x + x * x * x / 6.0;
            return Math.Exp(x) - 1.0;
        }

        public static double Softplus(double b) { return Log1p(Math.Exp(-Math.Abs(b))) + Math.Max(b, 0.0); }
    }

    // ======== 02b_zig_tables.cs ========
    // numpy's ziggurat tables for the standard normal (numpy/random/src/distributions/ziggurat_constants.h),
    // read bit for bit from numpy 2.5.3; wi and fi are the IEEE-754 bit patterns of the doubles.
    static partial class Zig
    {
        static readonly ulong[] KI = new ulong[] {
            0x000EF33D8025EF6AUL, 0x0000000000000000UL, 0x000C08BE98FBC6A8UL, 0x000DA354FABD8142UL,
            0x000E51F67EC1EEEAUL, 0x000EB255E9D3F77EUL, 0x000EEF4B817ECAB9UL, 0x000F19470AFA44AAUL,
            0x000F37ED61FFCB18UL, 0x000F4F469561255CUL, 0x000F61A5E41BA396UL, 0x000F707A755396A4UL,
            0x000F7CB2EC28449AUL, 0x000F86F10C6357D3UL, 0x000F8FA6578325DEUL, 0x000F9724C74DD0DAUL,
            0x000F9DA907DBF509UL, 0x000FA360F581FA74UL, 0x000FA86FDE5B4BF8UL, 0x000FACF160D354DCUL,
            0x000FB0FB6718B90FUL, 0x000FB49F8D5374C6UL, 0x000FB7EC2366FE77UL, 0x000FBAECE9A1E50EUL,
            0x000FBDAB9D040BEDUL, 0x000FC03060FF6C57UL, 0x000FC2821037A248UL, 0x000FC4A67AE25BD1UL,
            0x000FC6A2977AEE31UL, 0x000FC87AA92896A4UL, 0x000FCA325E4BDE85UL, 0x000FCBCCE902231AUL,
            0x000FCD4D12F839C4UL, 0x000FCEB54D8FEC99UL, 0x000FD007BF1DC930UL, 0x000FD1464DD6C4E6UL,
            0x000FD272A8E2F450UL, 0x000FD38E4FF0C91EUL, 0x000FD49A9990B478UL, 0x000FD598B8920F53UL,
            0x000FD689C08E99ECUL, 0x000FD76EA9C8E832UL, 0x000FD848547B08E8UL, 0x000FD9178BAD2C8CUL,
            0x000FD9DD07A7ADD2UL, 0x000FDA9970105E8CUL, 0x000FDB4D5DC02E20UL, 0x000FDBF95C5BFCD0UL,
            0x000FDC9DEBB99A7DUL, 0x000FDD3B8118729DUL, 0x000FDDD288342F90UL, 0x000FDE6364369F64UL,
            0x000FDEEE708D514EUL, 0x000FDF7401A6B42EUL, 0x000FDFF46599ED40UL, 0x000FE06FE4BC24F2UL,
            0x000FE0E6C225A258UL, 0x000FE1593C28B84CUL, 0x000FE1C78CBC3F99UL, 0x000FE231E9DB1CAAUL,
            0x000FE29885DA1B91UL, 0x000FE2FB8FB54186UL, 0x000FE35B33558D4AUL, 0x000FE3B799D0002AUL,
            0x000FE410E99EAD7FUL, 0x000FE46746D47734UL, 0x000FE4BAD34C095CUL, 0x000FE50BAED29524UL,
            0x000FE559F74EBC78UL, 0x000FE5A5C8E41212UL, 0x000FE5EF3E138689UL, 0x000FE6366FD91078UL,
            0x000FE67B75C6D578UL, 0x000FE6BE661E11AAUL, 0x000FE6FF55E5F4F2UL, 0x000FE73E5900A702UL,
            0x000FE77B823E9E39UL, 0x000FE7B6E37070A2UL, 0x000FE7F08D774243UL, 0x000FE8289053F08CUL,
            0x000FE85EFB35173AUL, 0x000FE893DC840864UL, 0x000FE8C741F0CEBCUL, 0x000FE8F9387D4EF6UL,
            0x000FE929CC879B1DUL, 0x000FE95909D388EAUL, 0x000FE986FB939AA2UL, 0x000FE9B3AC714866UL,
            0x000FE9DF2694B6D5UL, 0x000FEA0973ABE67CUL, 0x000FEA329CF166A4UL, 0x000FEA5AAB32952CUL,
            0x000FEA81A6D5741AUL, 0x000FEAA797DE1CF0UL, 0x000FEACC85F3D920UL, 0x000FEAF07865E63CUL,
            0x000FEB13762FEC13UL, 0x000FEB3585FE2A4AUL, 0x000FEB56AE3162B4UL, 0x000FEB76F4E284FAUL,
            0x000FEB965FE62014UL, 0x000FEBB4F4CF9D7CUL, 0x000FEBD2B8F449D0UL, 0x000FEBEFB16E2E3EUL,
            0x000FEC0BE31EBDE8UL, 0x000FEC2752B15A15UL, 0x000FEC42049DAFD3UL, 0x000FEC5BFD29F196UL,
            0x000FEC75406CEEF4UL, 0x000FEC8DD2500CB4UL, 0x000FECA5B6911F12UL, 0x000FECBCF0C427FEUL,
            0x000FECD38454FB15UL, 0x000FECE97488C8B3UL, 0x000FECFEC47F91B7UL, 0x000FED1377358528UL,
            0x000FED278F844903UL, 0x000FED3B10242F4CUL, 0x000FED4DFBAD586EUL, 0x000FED605498C3DDUL,
            0x000FED721D414FE8UL, 0x000FED8357E4A982UL, 0x000FED9406A42CC8UL, 0x000FEDA42B85B704UL,
            0x000FEDB3C8746AB4UL, 0x000FEDC2DF416652UL, 0x000FEDD171A46E52UL, 0x000FEDDF813C8AD3UL,
            0x000FEDED0F909980UL, 0x000FEDFA1E0FD414UL, 0x000FEE06AE124BC4UL, 0x000FEE12C0D95A06UL,
            0x000FEE1E579006E0UL, 0x000FEE29734B6524UL, 0x000FEE34150AE4BCUL, 0x000FEE3E3DB89B3CUL,
            0x000FEE47EE2982F4UL, 0x000FEE51271DB086UL, 0x000FEE59E9407F41UL, 0x000FEE623528B42EUL,
            0x000FEE6A0B5897F1UL, 0x000FEE716C3E077AUL, 0x000FEE7858327B82UL, 0x000FEE7ECF7B06BAUL,
            0x000FEE84D2484AB2UL, 0x000FEE8A60B66343UL, 0x000FEE8F7ACCC851UL, 0x000FEE94207E25DAUL,
            0x000FEE9851A829EAUL, 0x000FEE9C0E13485CUL, 0x000FEE9F557273F4UL, 0x000FEEA22762CCAEUL,
            0x000FEEA4836B42ACUL, 0x000FEEA668FC2D71UL, 0x000FEEA7D76ED6FAUL, 0x000FEEA8CE04FA0AUL,
            0x000FEEA94BE8333BUL, 0x000FEEA950296410UL, 0x000FEEA8D9C0075EUL, 0x000FEEA7E7897654UL,
            0x000FEEA678481D24UL, 0x000FEEA48AA29E83UL, 0x000FEEA21D22E4DAUL, 0x000FEE9F2E352024UL,
            0x000FEE9BBC26AF2EUL, 0x000FEE97C524F2E4UL, 0x000FEE93473C0A3AUL, 0x000FEE8E40557516UL,
            0x000FEE88AE369C7AUL, 0x000FEE828E7F3DFDUL, 0x000FEE7BDEA7B888UL, 0x000FEE749BFF37FFUL,
            0x000FEE6CC3A9BD5EUL, 0x000FEE64529E007EUL, 0x000FEE5B45A32888UL, 0x000FEE51994E57B6UL,
            0x000FEE474A0006CFUL, 0x000FEE3C53E12C50UL, 0x000FEE30B2E02AD8UL, 0x000FEE2462AD8205UL,
            0x000FEE175EB83C5AUL, 0x000FEE09A22A1447UL, 0x000FEDFB27E349CCUL, 0x000FEDEBEA76216CUL,
            0x000FEDDBE422047EUL, 0x000FEDCB0ECE39D3UL, 0x000FEDB964042CF4UL, 0x000FEDA6DCE938C9UL,
            0x000FED937237E98DUL, 0x000FED7F1C38A836UL, 0x000FED69D2B9C02BUL, 0x000FED538D06AE00UL,
            0x000FED3C41DEA422UL, 0x000FED23E76A2FD8UL, 0x000FED0A732FE644UL, 0x000FECEFDA07FE34UL,
            0x000FECD4100EB7B8UL, 0x000FECB708956EB4UL, 0x000FEC98B61230C1UL, 0x000FEC790A0DA978UL,
            0x000FEC57F50F31FEUL, 0x000FEC356686C962UL, 0x000FEC114CB4B335UL, 0x000FEBEB948E6FD0UL,
            0x000FEBC429A0B692UL, 0x000FEB9AF5EE0CDCUL, 0x000FEB6FE1C98542UL, 0x000FEB42D3AD1F9EUL,
            0x000FEB13B00B2D4BUL, 0x000FEAE2591A02E9UL, 0x000FEAAEAE992257UL, 0x000FEA788D8EE326UL,
            0x000FEA3FCFFD73E5UL, 0x000FEA044C8DD9F6UL, 0x000FE9C5D62F563BUL, 0x000FE9843BA947A4UL,
            0x000FE93F471D4728UL, 0x000FE8F6BD76C5D6UL, 0x000FE8AA5DC4E8E6UL, 0x000FE859E07AB1EAUL,
            0x000FE804F690A940UL, 0x000FE7AB488233C0UL, 0x000FE74C751F6AA5UL, 0x000FE6E8102AA202UL,
            0x000FE67DA0B6ABD8UL, 0x000FE60C9F38307EUL, 0x000FE5947338F742UL, 0x000FE51470977280UL,
            0x000FE48BD436F458UL, 0x000FE3F9BFFD1E37UL, 0x000FE35D35EEB19CUL, 0x000FE2B5122FE4FEUL,
            0x000FE20003995557UL, 0x000FE13C82788314UL, 0x000FE068C4EE67B0UL, 0x000FDF82B02B71AAUL,
            0x000FDE87C57EFEAAUL, 0x000FDD7509C63BFDUL, 0x000FDC46E529BF13UL, 0x000FDAF8F82E0282UL,
            0x000FD985E1B2BA75UL, 0x000FD7E6EF48CF04UL, 0x000FD613ADBD650BUL, 0x000FD40149E2F012UL,
            0x000FD1A1A7B4C7ACUL, 0x000FCEE204761F9EUL, 0x000FCBA8D85E11B2UL, 0x000FC7D26ECD2D22UL,
            0x000FC32B2F1E22EDUL, 0x000FBD6581C0B83AUL, 0x000FB606C4005434UL, 0x000FAC40582A2874UL,
            0x000F9E971E014598UL, 0x000F89FA48A41DFCUL, 0x000F66C5F7F0302CUL, 0x000F1A5A4B331C4AUL,
        };
        static readonly ulong[] WI_BITS = new ulong[] {
            0x3CCF493B7815D979UL, 0x3C8B8D0BE3FDF6C6UL, 0x3C9250AF3C2C5BB4UL, 0x3C957CB938443B61UL,
            0x3C9801FCE82FA70CUL, 0x3C9A230C2E4CD0BCUL, 0x3C9C004D2F3861F7UL, 0x3C9DAC2F5A747274UL,
            0x3C9F32482D4CD5C3UL, 0x3CA04D32278EBBADUL, 0x3CA0F5053B025D43UL, 0x3CA192A697413677UL,
            0x3CA227A28F7A1AF5UL, 0x3CA2B52E3863D880UL, 0x3CA33C3FC05791F5UL, 0x3CA3BD9EC1A2B12FUL,
            0x3CA439EF8DFF9B55UL, 0x3CA4B1BB363DFEA7UL, 0x3CA52575621AD374UL, 0x3CA59580A707CE96UL,
            0x3CA60231CFD97EEAUL, 0x3CA66BD261A37C3DUL, 0x3CA6D2A292000570UL, 0x3CA736DAD346F8A6UL,
            0x3CA798AD10B32A77UL, 0x3CA7F845AD46F543UL, 0x3CA855CC53430A77UL, 0x3CA8B1649E7B769AUL,
            0x3CA90B2EA94ECF98UL, 0x3CA96347822C1EEAUL, 0x3CA9B9C98E38C546UL, 0x3CAA0ECCDCA4A72CUL,
            0x3CAA62676D77CD59UL, 0x3CAAB4AD6E101630UL, 0x3CAB05B16D136C9CUL, 0x3CAB558487427A29UL,
            0x3CABA4368E529F3AUL, 0x3CABF1D62ABF8232UL, 0x3CAC3E70F9594EF3UL, 0x3CAC8A13A5323B61UL,
            0x3CACD4C9FE72268BUL, 0x3CAD1E9F0E80B748UL, 0x3CAD679D29E41F10UL, 0x3CADAFCE0023B8C3UL,
            0x3CADF73AA9F17653UL, 0x3CAE3DEBB5D2EDFEUL, 0x3CAE83E9337A6F00UL, 0x3CAEC93ABDF982CEUL,
            0x3CAF0DE784F06226UL, 0x3CAF51F654D8F688UL, 0x3CAF956D9E87D7AEUL, 0x3CAFD8537DFA2EACUL,
            0x3CB00D56E04234ECUL, 0x3CB02E40F5398F9AUL, 0x3CB04EEA9E16A5FCUL, 0x3CB06F565B72A010UL,
            0x3CB08F869071F40BUL, 0x3CB0AF7D84BC6113UL, 0x3CB0CF3D664BCC7FUL, 0x3CB0EEC84B16086BUL,
            0x3CB10E20329515EEUL, 0x3CB12D4707310FBEUL, 0x3CB14C3E9F8E9141UL, 0x3CB16B08BFC4201EUL,
            0x3CB189A71A78DA34UL, 0x3CB1A81B51EE6D88UL, 0x3CB1C666F8F82ACBUL, 0x3CB1E48B93E0D42EUL,
            0x3CB2028A9940A09FUL, 0x3CB2206572C4C6E9UL, 0x3CB23E1D7DE9C31FUL, 0x3CB25BB40CA96BFBUL,
            0x3CB2792A661DD37FUL, 0x3CB29681C719D71BUL, 0x3CB2B3BB62B82EDAUL, 0x3CB2D0D862E1B853UL,
            0x3CB2EDD9E8CBA98EUL, 0x3CB30AC10D6E48D7UL, 0x3CB3278EE1F4B930UL, 0x3CB3444470265EA1UL,
            0x3CB360E2BACA52D5UL, 0x3CB37D6ABE05586AUL, 0x3CB399DD6FB2B264UL, 0x3CB3B63BBFB83D03UL,
            0x3CB3D28698561DE0UL, 0x3CB3EEBEDE725A83UL, 0x3CB40AE571E09E74UL, 0x3CB426FB2DA6745DUL,
            0x3CB44300E83C30A4UL, 0x3CB45EF773CAC75DUL, 0x3CB47ADF9E66C336UL, 0x3CB496BA32488F2FUL,
            0x3CB4B287F602415DUL, 0x3CB4CE49ACB311DCUL, 0x3CB4EA001638A605UL, 0x3CB505ABEF5E5562UL,
            0x3CB5214DF20A8B5AUL, 0x3CB53CE6D56A664FUL, 0x3CB558774E1BB2C8UL, 0x3CB574000E555F78UL,
            0x3CB58F81C60E8514UL, 0x3CB5AAFD23241B59UL, 0x3CB5C672D17D733DUL, 0x3CB5E1E37B2F8CD3UL,
            0x3CB5FD4FC89F5E38UL, 0x3CB618B860A31FC3UL, 0x3CB6341DE8A2B0A2UL, 0x3CB64F8104B7260BUL,
            0x3CB66AE257C99672UL, 0x3CB6864283B13137UL, 0x3CB6A1A22950B2B1UL, 0x3CB6BD01E8B343BBUL,
            0x3CB6D8626128D352UL, 0x3CB6F3C43161F854UL, 0x3CB70F27F78B68EBUL, 0x3CB72A8E516914C6UL,
            0x3CB745F7DC70EEDCUL, 0x3CB7616535E5731FUL, 0x3CB77CD6FAEFF449UL, 0x3CB7984DC8BABD93UL,
            0x3CB7B3CA3C8B1409UL, 0x3CB7CF4CF3DB22FBUL, 0x3CB7EAD68C73DEE7UL, 0x3CB80667A486EA1FUL,
            0x3CB82200DAC88676UL, 0x3CB83DA2CE899F15UL, 0x3CB8594E1FD1F5BDUL, 0x3CB875036F7A7EC5UL,
            0x3CB890C35F47F72DUL, 0x3CB8AC8E9205C043UL, 0x3CB8C865ABA10C9CUL, 0x3CB8E44951446A27UL,
            0x3CB9003A2973B58FUL, 0x3CB91C38DC288347UL, 0x3CB9384612EF0AFCUL, 0x3CB954627903A28AUL,
            0x3CB9708EBB70D5EEUL, 0x3CB98CCB892E2A31UL, 0x3CB9A919933F99BFUL, 0x3CB9C5798CD5D92CUL,
            0x3CB9E1EC2B6F7411UL, 0x3CB9FE7226FAD24AUL, 0x3CBA1B0C39F93692UL, 0x3CBA37BB21A2C85BUL,
            0x3CBA547F9E0BBB88UL, 0x3CBA715A724AA9A4UL, 0x3CBA8E4C64A0313DUL, 0x3CBAAB563E9FF108UL,
            0x3CBAC878CD5AF5CEUL, 0x3CBAE5B4E18BB336UL, 0x3CBB030B4FC3A11AUL, 0x3CBB207CF09A985BUL,
            0x3CBB3E0AA0E00C00UL, 0x3CBB5BB541CE3D03UL, 0x3CBB797DB93F8927UL, 0x3CBB9764F1E5F73CUL,
            0x3CBBB56BDB85256EUL, 0x3CBBD3936B2EC0A2UL, 0x3CBBF1DC9B81AE83UL, 0x3CBC10486CEC16A0UL,
            0x3CBC2ED7E5F07A2DUL, 0x3CBC4D8C136E0D1CUL, 0x3CBC6C6608EC8705UL, 0x3CBC8B66E0EBA617UL,
            0x3CBCAA8FBD36A2ABUL, 0x3CBCC9E1C73BD690UL, 0x3CBCE95E3068E037UL, 0x3CBD0906328B8F6EUL,
            0x3CBD28DB1037EF20UL, 0x3CBD48DE1533C647UL, 0x3CBD691096E7F123UL, 0x3CBD8973F4D7FBA5UL,
            0x3CBDAA0999206E70UL, 0x3CBDCAD2F8FC490EUL, 0x3CBDEBD195522E37UL, 0x3CBE0D06FB49D21CUL,
            0x3CBE2E74C4EA46F6UL, 0x3CBE501C99C1D188UL, 0x3CBE72002F97FE25UL, 0x3CBE94214B2ABF0AUL,
            0x3CBEB681C0F76F08UL, 0x3CBED9237610A73AUL, 0x3CBEFC086101ECA9UL, 0x3CBF1F328AC25321UL,
            0x3CBF42A40FB74D6DUL, 0x3CBF665F20C90168UL, 0x3CBF8A6604899782UL, 0x3CBFAEBB187122BFUL,
            0x3CBFD360D22FE785UL, 0x3CBFF859C118F60BUL, 0x3CC00ED447D3A075UL, 0x3CC021A8028FC947UL,
            0x3CC034A983A902ABUL, 0x3CC047DA4E3EF5C7UL, 0x3CC05B3BF6ADB37EUL, 0x3CC06ED023A72668UL,
            0x3CC082988F632E17UL, 0x3CC0969708E8A254UL, 0x3CC0AACD7571C0C4UL, 0x3CC0BF3DD1EED448UL,
            0x3CC0D3EA34AA3D30UL, 0x3CC0E8D4CF116593UL, 0x3CC0FDFFEFA69FB6UL, 0x3CC1136E04207041UL,
            0x3CC129219BBB5D35UL, 0x3CC13F1D69C4096DUL, 0x3CC1556448602E3BUL, 0x3CC16BF93B9DEEF3UL,
            0x3CC182DF74D21261UL, 0x3CC19A1A564EEBACUL, 0x3CC1B1AD777F2F8EUL, 0x3CC1C99CA971A694UL,
            0x3CC1E1EBFBE4AE39UL, 0x3CC1FA9FC2E2D901UL, 0x3CC213BC9D04CC81UL, 0x3CC22D477A6FD3EEUL,
            0x3CC24745A4AC9C24UL, 0x3CC261BCC77658E0UL, 0x3CC27CB2FAA8592EUL, 0x3CC2982ECD770E78UL,
            0x3CC2B437532A0A52UL, 0x3CC2D0D43196DB97UL, 0x3CC2EE0DB1A978F5UL, 0x3CC30BECD256AEEEUL,
            0x3CC32A7B5E68A4A3UL, 0x3CC349C405AE12A3UL, 0x3CC369D27A33A840UL, 0x3CC38AB39256410AUL,
            0x3CC3AC7570AE88FAUL, 0x3CC3CF27B31704A6UL, 0x3CC3F2DBAA60F475UL, 0x3CC417A49CB9E5DAUL,
            0x3CC43D9815545E94UL, 0x3CC464CE44A73A15UL, 0x3CC48D62759C43BCUL, 0x3CC4B7739D6B5A27UL,
            0x3CC4E3250DCD8902UL, 0x3CC5109F53E9AC41UL, 0x3CC54011523A7E42UL, 0x3CC571B1A94AE41BUL,
            0x3CC5A5C08B718DD9UL, 0x3CC5DC8A243AD0FEUL, 0x3CC61669CF861E4CUL, 0x3CC653CE7B006AEAUL,
            0x3CC69540BE9FE5C3UL, 0x3CC6DB6B8D09E232UL, 0x3CC72728F05F7A34UL, 0x3CC7799556090673UL,
            0x3CC7D42DF4D6CE8CUL, 0x3CC839030529F234UL, 0x3CC8AB0FBFAA7C14UL, 0x3CC92EE0946F4496UL,
            0x3CC9CBEE014057ABUL, 0x3CCA8FDC7894775AUL, 0x3CCB981F3878FDB1UL, 0x3CCD3BB48209AD33UL,
        };
        static readonly ulong[] FI_BITS = new ulong[] {
            0x3FF0000000000000UL, 0x3FEF446AC979F087UL, 0x3FEEB7545B6CA915UL, 0x3FEE3F11E027F077UL,
            0x3FEDD36FA704DE95UL, 0x3FED70920657BCF2UL, 0x3FED144978A119DCUL, 0x3FECBD33A8A72DEBUL,
            0x3FEC6A5ECEA9787FUL, 0x3FEC1B1CD9EEBAEAUL, 0x3FEBCEEB4EE1DC82UL, 0x3FEB85653A8FF552UL,
            0x3FEB3E3A8234DD10UL, 0x3FEAF92A3F6CE8A2UL, 0x3FEAB5FEF17A2504UL, 0x3FEA748BD550C9E1UL,
            0x3FEA34AAFDF5AF0FUL, 0x3FE9F63BEE651FD8UL, 0x3FE9B9228D240681UL, 0x3FE97D4657617AC1UL,
            0x3FE94291C21B7A47UL, 0x3FE908F1BD31714FUL, 0x3FE8D0554FE60AA8UL, 0x3FE898AD48BADF02UL,
            0x3FE861EBFC37BCACUL, 0x3FE82C050F56CF6EUL, 0x3FE7F6ED4B20E2CBUL, 0x3FE7C29A779C6858UL,
            0x3FE78F033CA0B0D5UL, 0x3FE75C1F0770D856UL, 0x3FE729E5F43F6D12UL, 0x3FE6F850BAEA7AEEUL,
            0x3FE6C7589E635A89UL, 0x3FE696F75E513B2AUL, 0x3FE667272A92E323UL, 0x3FE637E298550C18UL,
            0x3FE6092498802665UL, 0x3FE5DAE86F4AFF6AUL, 0x3FE5AD29ACC85C89UL, 0x3FE57FE4264C8D8FUL,
            0x3FE55313F08D9E46UL, 0x3FE526B55A656CD5UL, 0x3FE4FAC4E820B667UL, 0x3FE4CF3F4F494EC0UL,
            0x3FE4A42172DC5278UL, 0x3FE479685FDF5012UL, 0x3FE44F114A493679UL, 0x3FE425198A355FE3UL,
            0x3FE3FB7E99585B82UL, 0x3FE3D23E10AF31A3UL, 0x3FE3A955A662CD0EUL, 0x3FE380C32BDA00D5UL,
            0x3FE358848BF550E9UL, 0x3FE33097C9703A35UL, 0x3FE308FAFD6438EFUL, 0x3FE2E1AC55EA3BEEUL,
            0x3FE2BAAA14D7954AUL, 0x3FE293F28E93CD15UL, 0x3FE26D84290504EDUL, 0x3FE2475D5A90DB84UL,
            0x3FE2217CA92FF7F2UL, 0x3FE1FBE0A9929620UL, 0x3FE1D687FE549969UL, 0x3FE1B171573FD111UL,
            0x3FE18C9B709B3C50UL, 0x3FE16805128639DAUL, 0x3FE143AD105EA99CUL, 0x3FE11F9248311F38UL,
            0x3FE0FBB3A2325913UL, 0x3FE0D810104142A0UL, 0x3FE0B4A68D70D9AEUL, 0x3FE091761D995D81UL,
            0x3FE06E7DCCF03C36UL, 0x3FE04BBCAFA63F2EUL, 0x3FE02931E18B822AUL, 0x3FE006DC85B8CAC4UL,
            0x3FDFC9778C7BBDA1UL, 0x3FDF859DA7A900CAUL, 0x3FDF4229CB2F7AF3UL, 0x3FDEFF1A717E8F95UL,
            0x3FDEBC6E20BD1F54UL, 0x3FDE7A236A4EC3C5UL, 0x3FDE3838EA5F9B85UL, 0x3FDDF6AD47763A09UL,
            0x3FDDB57F320B56B1UL, 0x3FDD74AD6426DE33UL, 0x3FDD3436A1021080UL, 0x3FDCF419B4AE5B6DUL,
            0x3FDCB45573C0A848UL, 0x3FDC74E8BB00D7C7UL, 0x3FDC35D26F1D2CB8UL, 0x3FDBF7117C616A17UL,
            0x3FDBB8A4D6716D91UL, 0x3FDB7A8B7807131BUL, 0x3FDB3CC462B331CAUL, 0x3FDAFF4E9EA18552UL,
            0x3FDAC2293A5F5A9EUL, 0x3FDA85534AA4D880UL, 0x3FDA48CBEA20C04DUL, 0x3FDA0C923946843EUL,
            0x3FD9D0A55E1E93DFUL, 0x3FD995048418C0C6UL, 0x3FD959AEDBE09F93UL, 0x3FD91EA39B33CB17UL,
            0x3FD8E3E1FCB9F115UL, 0x3FD8A9693FDE9188UL, 0x3FD86F38A8AC5AB6UL, 0x3FD8354F7FAA0DD9UL,
            0x3FD7FBAD11B8D911UL, 0x3FD7C250AFF414B0UL, 0x3FD78939AF9252EBUL, 0x3FD7506769C7B1EDUL,
            0x3FD717D93BA9614CUL, 0x3FD6DF8E86124CAAUL, 0x3FD6A786AD88DE21UL, 0x3FD66FC11A25CBE2UL,
            0x3FD6383D377BE515UL, 0x3FD600FA7480D2C8UL, 0x3FD5C9F84376C244UL, 0x3FD5933619D6EEBEUL,
            0x3FD55CB3703D0100UL, 0x3FD5266FC2533BEDUL, 0x3FD4F06A8EBF6D92UL, 0x3FD4BAA357109CA2UL,
            0x3FD485199FAD6AD4UL, 0x3FD44FCCEFC324FEUL, 0x3FD41ABCD1357A19UL, 0x3FD3E5E8D08ED2DBUL,
            0x3FD3B1507CF143AEUL, 0x3FD37CF368081379UL, 0x3FD348D125F9D19EUL, 0x3FD314E94D5AF62FUL,
            0x3FD2E13B77210766UL, 0x3FD2ADC73E963FDDUL, 0x3FD27A8C414DB11EUL, 0x3FD2478A1F17DE89UL,
            0x3FD214C079F7CC9EUL, 0x3FD1E22EF6188116UL, 0x3FD1AFD539C2F050UL, 0x3FD17DB2ED5454E8UL,
            0x3FD14BC7BB34EE67UL, 0x3FD11A134FCF2423UL, 0x3FD0E895598709C4UL, 0x3FD0B74D88B242DAUL,
            0x3FD0863B8F904336UL, 0x3FD0555F2242E9D9UL, 0x3FD024B7F6C7747EUL, 0x3FCFE88B89DF93C5UL,
            0x3FCF88108CB83235UL, 0x3FCF27FE6CE998D2UL, 0x3FCEC854A4C99C44UL, 0x3FCE6912B2283CDDUL,
            0x3FCE0A3816457184UL, 0x3FCDABC455C7900AUL, 0x3FCD4DB6F8B2514FUL, 0x3FCCF00F8A5E6FCCUL,
            0x3FCC92CD9971DF53UL, 0x3FCC35F0B7D89D47UL, 0x3FCBD9787ABE18A1UL, 0x3FCB7D647A8731AAUL,
            0x3FCB21B452CCD13AUL, 0x3FCAC667A2571807UL, 0x3FCA6B7E0B19267EUL, 0x3FCA10F7322D7E3DUL,
            0x3FC9B6D2BFD2FE5AUL, 0x3FC95D105F6A7C27UL, 0x3FC903AFBF74FA69UL, 0x3FC8AAB09192815BUL,
            0x3FC852128A819A38UL, 0x3FC7F9D5621F7175UL, 0x3FC7A1F8D368A323UL, 0x3FC74A7C9C7AB5A6UL,
            0x3FC6F3607E964716UL, 0x3FC69CA43E21F25CUL, 0x3FC64647A2ADF19CUL, 0x3FC5F04A76F883F9UL,
            0x3FC59AAC88F31D6CUL, 0x3FC5456DA9C86835UL, 0x3FC4F08DADE31FC1UL, 0x3FC49C0C6CF5CE2DUL,
            0x3FC447E9C20375D5UL, 0x3FC3F4258B6931AEUL, 0x3FC3A0BFAAE8D7EEUL, 0x3FC34DB805B4AB88UL,
            0x3FC2FB0E847C2A65UL, 0x3FC2A8C3137A071AUL, 0x3FC256D5A2835EB7UL, 0x3FC2054625183C34UL,
            0x3FC1B41492757D42UL, 0x3FC16340E5A82D63UL, 0x3FC112CB1DA26EB9UL, 0x3FC0C2B33D5209BAUL,
            0x3FC072F94BB8BF85UL, 0x3FC0239D54067D2AUL, 0x3FBFA93ECB6B222CUL, 0x3FBF0BFF29520E1CUL,
            0x3FBE6F7BF29AA54BUL, 0x3FBDD3B56176E88FUL, 0x3FBD38ABB9BD91E5UL, 0x3FBC9E5F493B740AUL,
            0x3FBC04D0680B1015UL, 0x3FBB6BFF78F2E233UL, 0x3FBAD3ECE9CAF633UL, 0x3FBA3C9933EA6286UL,
            0x3FB9A604DC9D5B19UL, 0x3FB9103075A4A0ABUL, 0x3FB87B1C9DBF2852UL, 0x3FB7E6CA013EEFD6UL,
            0x3FB753395AAA1176UL, 0x3FB6C06B73694A4CUL, 0x3FB62E6124854D18UL, 0x3FB59D1B577466A4UL,
            0x3FB50C9B06FA2BAEUL, 0x3FB47CE1401B2213UL, 0x3FB3EDEF23269A86UL, 0x3FB35FC5E4D93E70UL,
            0x3FB2D266CF9B3111UL, 0x3FB245D344DD0D91UL, 0x3FB1BA0CBE97897DUL, 0x3FB12F14D0F2179DUL,
            0x3FB0A4ED2C159625UL, 0x3FB01B979E30E497UL, 0x3FAF262C2B6C6E35UL, 0x3FAE16D547B25181UL,
            0x3FAD092EFEADF162UL, 0x3FABFD3E0F282A2CUL, 0x3FAAF30790385F70UL, 0x3FA9EA90F9295563UL,
            0x3FA8E3E02A68B5ABUL, 0x3FA7DEFB77AF271EUL, 0x3FA6DBE9B398D064UL, 0x3FA5DAB23CF2ADD4UL,
            0x3FA4DB5D0E11275DUL, 0x3FA3DDF2CE98EECBUL, 0x3FA2E27CE83DF497UL, 0x3FA1E9059F1F6ABCUL,
            0x3FA0F1982E968011UL, 0x3F9FF881D718A5C4UL, 0x3F9E121ADB828C75UL, 0x3F9C301983CD091AUL,
            0x3F9A529F4E22EBF8UL, 0x3F9879D1B600C10AUL, 0x3F96A5DAF40BBF82UL, 0x3F94D6EAF2FBB064UL,
            0x3F930D388DAB5E13UL, 0x3F91490334603012UL, 0x3F8F152A4F72DD49UL, 0x3F8BA48D274F8FACUL,
            0x3F8841040D8DA478UL, 0x3F84EB96421ACFE0UL, 0x3F81A59229952F92UL, 0x3F7CE160F8EC6837UL,
            0x3F769EA8D90CB85DUL, 0x3F708A1F03B0B1FDUL, 0x3F655F9F43C1B067UL, 0x3F54A605B6B9F70FUL,
        };
        internal const ulong R_BITS = 0x400D3BB48209AD33UL;   // ziggurat_nor_r = 3.654152885361009
        internal const ulong INV_R_BITS = 0x3FD183AA6C20E8C1UL;   // ziggurat_nor_inv_r = 0.2736612373297583
    }

    // ======== 03_lbcmd.cs ========
    /// <summary>LB-CMD/1 word encodings (SPEC section 3).</summary>
    public static class Words
    {
        /// <summary>32 signs per word; bit b is element 32k+b, 1 meaning +1. Values &gt;= 0 (including -0) count as +1.</summary>
        public static int[] PackSigns(double[] s)
        {
            if (s.Length % 32 != 0) throw new EngineError("sign count must be a multiple of 32");
            var w = new int[s.Length / 32];
            for (int k = 0; k < w.Length; k++)
            {
                uint u = 0;
                for (int b = 0; b < 32; b++) if (s[32 * k + b] > 0) u |= 1u << b;
                w[k] = unchecked((int)u);
            }
            return w;
        }

        public static int[] PackSignsOf(float[] x)
        {
            var w = new int[x.Length / 32];
            for (int k = 0; k < w.Length; k++)
            {
                uint u = 0;
                for (int b = 0; b < 32; b++) if (x[32 * k + b] >= 0) u |= 1u << b;
                w[k] = unchecked((int)u);
            }
            return w;
        }

        public static bool SignBit(int[] words, long i) { return ((words[i >> 5] >> (int)(i & 31)) & 1) != 0; }

        public static int[] PackU16(double[] x)
        {
            int n = x.Length;
            var q = new uint[n + (n % 2)];
            for (int i = 0; i < n; i++)
            {
                double r = U.RoundHalfEven(x[i] * 65536.0);
                if (r < 0 || r > 65535) throw new EngineError("U0.16 range exceeded");
                q[i] = (uint)r;
            }
            var w = new int[q.Length / 2];
            for (int k = 0; k < w.Length; k++) w[k] = unchecked((int)(q[2 * k] | (q[2 * k + 1] << 16)));
            return w;
        }

        public static float[] UnpackU16(int[] words, int n, int shift)
        {
            var o = new float[n];
            float sc = (float)Math.Pow(2, shift);
            for (int i = 0; i < n; i++)
            {
                uint u = unchecked((uint)words[i >> 1]);
                uint q = (i & 1) == 0 ? (u & 0xFFFF) : (u >> 16);
                o[i] = (float)(q / 65536.0) * sc;
            }
            return o;
        }

        public static long Q16(double x)
        {
            double r = U.RoundHalfEven(x * 65536.0);
            if (r < int.MinValue) r = int.MinValue;
            if (r > int.MaxValue) r = int.MaxValue;
            return (long)r;
        }

        public static float FromQ16(long w) { return (float)(w / 65536.0); }

        public static ushort ToBf16(float x)
        {
            ulong u = (ulong)BitConverter.ToUInt32(BitConverter.GetBytes(x), 0);
            u = u + 0x7FFFUL + ((u >> 16) & 1UL);
            return (ushort)((u >> 16) & 0xFFFFUL);
        }

        public static float FromBf16(ushort b) { return BitConverter.ToSingle(BitConverter.GetBytes((uint)b << 16), 0); }

        public static float Bf16Round(float x) { return FromBf16(ToBf16(x)); }

        public static int[] PackBf16(float[] x)
        {
            int n = x.Length;
            var w = new int[(n + 1) / 2];
            for (int k = 0; k < w.Length; k++)
            {
                uint lo = ToBf16(x[2 * k]);
                uint hi = 2 * k + 1 < n ? ToBf16(x[2 * k + 1]) : 0u;
                w[k] = unchecked((int)(lo | (hi << 16)));
            }
            return w;
        }

        public static float[] UnpackBf16(int[] words, int n)
        {
            var o = new float[n];
            for (int i = 0; i < n; i++)
            {
                uint u = unchecked((uint)words[i >> 1]);
                o[i] = FromBf16((ushort)((i & 1) == 0 ? (u & 0xFFFF) : (u >> 16)));
            }
            return o;
        }

        public static float[] UnpackSigns(int[] words, int n)
        {
            var o = new float[n];
            for (int i = 0; i < n; i++) o[i] = SignBit(words, i) ? 1f : -1f;
            return o;
        }
    }

    /// <summary>One LB-CMD/1 shard being written (lb_cmd.Shard).</summary>
    public sealed class ShardWriter
    {
        public static readonly string[] WeightComment = {
            "rem LK/Vexa LittleBit .cmd weight shard, LB-CMD/1 (TN-2026-LB-CMD-WEIGHTS-5DLLM-8S namespace)",
            "rem Do not run it: it only sets variables. tools\\LB_CMD.cmd and tools\\VERIFY_WEIGHTS.cmd read it as text." };
        public static readonly string[] DataComment = {
            "rem LK/Vexa LB-CMD/1 data shard: 4 bytes per word, little-endian; the last word of a file is zero-padded.",
            "rem Do not run it: it only sets variables. tools\\MAKE_DATA.cmd unpack writes the original file back." };

        public readonly List<KeyValuePair<string, string>> Head = new List<KeyValuePair<string, string>>();
        readonly StringBuilder payload = new StringBuilder(1 << 20);
        public long Lines, L1;
        public string[] Comment = WeightComment;

        public ShardWriter(string model, string shard, string tier, long epsQ16, string pin)
        {
            H("LB_FORMAT", "LB-CMD/1"); H("LB_MODEL", model); H("LB_SHARD", shard); H("LB_TIER", tier);
            H("LB_RMSNORM_EPS_Q16", epsQ16.ToString(U.Inv)); H("LB_PIN", pin);
        }

        public ShardWriter() { }

        public ShardWriter H(string k, string v) { Head.Add(new KeyValuePair<string, string>(k, v)); return this; }

        public void WordsOf(string prefix, IList<long> w)
        {
            for (int i = 0; i < w.Count; i++)
            {
                payload.Append("set \"").Append(prefix).Append('_').Append(i.ToString(U.Inv)).Append('=').Append(w[i].ToString(U.Inv)).Append("\"\r\n");
                L1 += Math.Abs(w[i]);
            }
            Lines += w.Count;
        }

        public void Words(string prefix, int[] w)
        {
            for (int i = 0; i < w.Length; i++)
            {
                payload.Append("set \"").Append(prefix).Append('_').Append(i.ToString(U.Inv)).Append('=').Append(w[i].ToString(U.Inv)).Append("\"\r\n");
                L1 += Math.Abs((long)w[i]);
            }
            Lines += w.Length;
        }

        public void AppendRaw(string line, long absValue)
        {
            payload.Append(line);
            Lines += 1;
            L1 += absValue;
        }

        public void Scalar(string name, long v)
        {
            payload.Append("set \"").Append(name).Append('=').Append(v.ToString(U.Inv)).Append("\"\r\n");
            Lines += 1;
            L1 += Math.Abs(v);
        }

        public JObj Write(string path)
        {
            byte[] pl = U.Ascii.GetBytes(payload.ToString());
            string ph = U.Sha512Hex(pl);
            var sb = new StringBuilder();
            sb.Append("@echo off\r\n");
            foreach (string c in Comment) sb.Append(c).Append("\r\n");
            foreach (var kv in Head) sb.Append("set \"").Append(kv.Key).Append('=').Append(kv.Value).Append("\"\r\n");
            sb.Append("set \"LB_PAYLOAD_LINES=").Append(Lines.ToString(U.Inv)).Append("\"\r\n");
            sb.Append("set \"LB_PAYLOAD_SHA512=").Append(ph).Append("\"\r\n");
            sb.Append("set \"LB_L1_CHECKSUM=").Append(L1.ToString(U.Inv)).Append("\"\r\n");
            sb.Append("rem ---- payload ----\r\n");
            byte[] head = U.Ascii.GetBytes(sb.ToString());
            byte[] tail = U.Ascii.GetBytes("rem ---- end of payload ----\r\nexit /b 0\r\n");
            var all = new byte[head.Length + pl.Length + tail.Length];
            Buffer.BlockCopy(head, 0, all, 0, head.Length);
            Buffer.BlockCopy(pl, 0, all, head.Length, pl.Length);
            Buffer.BlockCopy(tail, 0, all, head.Length + pl.Length, tail.Length);
            U.WriteBytes(path, all);
            var r = new JObj();
            r["file"] = Path.GetFileName(path);
            r["bytes"] = (long)all.Length;
            r["sha512"] = U.Sha512Hex(all);
            r["payload_sha512"] = ph;
            r["payload_lines"] = Lines;
            r["l1_checksum"] = L1;
            return r;
        }
    }

    /// <summary>One LB-CMD/1 shard read back and checked (lb_cmd.read_shard).</summary>
    public sealed class ShardData
    {
        public readonly Dictionary<string, string> Head = new Dictionary<string, string>(StringComparer.Ordinal);
        public readonly Dictionary<string, int[]> Fam = new Dictionary<string, int[]>(StringComparer.Ordinal);
        public readonly List<string> FamOrder = new List<string>();
        public readonly Dictionary<string, long> Scal = new Dictionary<string, long>(StringComparer.Ordinal);
        public string FileSha512, PayloadSha512, Name;
        public long Bytes, Lines, L1, BoundAnyValues;
        public bool PayloadShaOk, LinesOk, L1Ok;
        public int Families { get { return Fam.Count; } }

        static readonly byte[] START = U.Ascii.GetBytes("rem ---- payload ----\r\n"), END = U.Ascii.GetBytes("rem ---- end of payload ----\r\n");

        public int[] F(string name)
        {
            int[] v;
            if (!Fam.TryGetValue(name, out v)) throw new EngineError(Name + ": family " + name + " missing");
            return v;
        }

        public long S(string name)
        {
            long v;
            if (!Scal.TryGetValue(name, out v)) throw new EngineError(Name + ": scalar " + name + " missing");
            return v;
        }

        public static Dictionary<string, string> HeadOf(string text)
        {
            var d = new Dictionary<string, string>(StringComparer.Ordinal);
            foreach (string line in text.Split(new[] { "\r\n" }, StringSplitOptions.None))
            {
                if (!line.StartsWith("set \"", StringComparison.Ordinal) || !line.EndsWith("\"", StringComparison.Ordinal) || line.Length < 7) continue;
                string kv = line.Substring(5, line.Length - 6);
                int eq = kv.IndexOf('=');
                if (eq <= 0 || kv.IndexOf('"') >= 0) continue;
                string k = kv.Substring(0, eq);
                bool ok = true;
                foreach (char c in k) if (!((c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_')) ok = false;
                if (ok) d[k] = kv.Substring(eq + 1);
            }
            return d;
        }

        /// <summary>strict: raise on any inconsistency (the loader); otherwise record the checks (the verifier).</summary>
        public static ShardData Read(string path, bool strict, bool keepValues)
        {
            byte[] data = File.ReadAllBytes(path);
            var s = Parse(data, Path.GetFileName(path), strict, keepValues);
            s.FileSha512 = U.Sha512Hex(data);
            return s;
        }

        public static ShardData Parse(byte[] data, string name, bool strict, bool keepValues)
        {
            var s = new ShardData();
            s.Name = name;
            s.Bytes = data.Length;
            int a = U.IndexOf(data, START, 0);
            if (a < 0) throw new EngineError(name + ": no payload start line");
            int i0 = a + START.Length;
            int i1 = U.IndexOf(data, END, i0);
            if (i1 < 0) throw new EngineError(name + ": no payload end line");
            foreach (var kv in HeadOf(U.Ascii.GetString(data, 0, i0))) s.Head[kv.Key] = kv.Value;
            string want;
            s.Head.TryGetValue("LB_PAYLOAD_SHA512", out want);
            s.PayloadSha512 = U.Sha512Hex(data, i0, i1 - i0);
            s.PayloadShaOk = s.PayloadSha512 == want;
            if (strict && !s.PayloadShaOk) throw new EngineError(name + ": payload SHA-512 differs from its header");
            // payload: set "NAME=V"\r\n or set "NAME_IDX=V"\r\n, nothing else
            string cur = null;
            var buf = new List<int>();
            long nxt = 0, lines = 0, l1 = 0, slack = 0;
            bool shapeOk = true;
            int p = i0;
            var famSeen = new HashSet<string>(StringComparer.Ordinal);
            while (p < i1)
            {
                if (p + 5 > i1 || data[p] != (byte)'s' || data[p + 1] != (byte)'e' || data[p + 2] != (byte)'t' || data[p + 3] != (byte)' ' || data[p + 4] != (byte)'"')
                { shapeOk = false; break; }
                int k0 = p + 5, k = k0;
                while (k < i1 && ((data[k] >= 'A' && data[k] <= 'Z') || (data[k] >= '0' && data[k] <= '9') || data[k] == '_')) k++;
                if (k == k0 || k >= i1 || data[k] != (byte)'=') { shapeOk = false; break; }
                int v0 = k + 1, v = v0;
                if (v < i1 && data[v] == (byte)'-') v++;
                int d0 = v;
                long val = 0;
                while (v < i1 && data[v] >= '0' && data[v] <= '9') { val = val * 10 + (data[v] - '0'); v++; if (val > 3000000000L) { shapeOk = false; break; } }
                if (!shapeOk) break;
                if (v == d0 || v + 3 > i1 || data[v] != (byte)'"' || data[v + 1] != (byte)'\r' || data[v + 2] != (byte)'\n') { shapeOk = false; break; }
                if (data[v0] == (byte)'-') val = -val;
                int vlen = v - v0;
                slack += 11 - vlen;
                string key = U.Ascii.GetString(data, k0, k - k0);
                lines++;
                l1 += Math.Abs(val);
                if (val < int.MinValue || val > int.MaxValue) { shapeOk = false; break; }
                int us = key.LastIndexOf('_');
                bool isFam = us > 0 && us < key.Length - 1;
                if (isFam) for (int c = us + 1; c < key.Length; c++) if (key[c] < '0' || key[c] > '9') { isFam = false; break; }
                if (!isFam)
                {
                    if (s.Scal.ContainsKey(key) || s.Fam.ContainsKey(key) || key == cur)
                    {
                        if (strict) throw new EngineError(name + ": " + key + " repeated");
                        shapeOk = false;
                    }
                    s.Scal[key] = val;
                }
                else
                {
                    string fam = key.Substring(0, us);
                    long idx = long.Parse(key.Substring(us + 1), U.Inv);
                    if (fam != cur)
                    {
                        if (cur != null && keepValues) { s.Fam[cur] = buf.ToArray(); s.FamOrder.Add(cur); }
                        else if (cur != null) { s.Fam[cur] = null; s.FamOrder.Add(cur); }
                        if (famSeen.Contains(fam))
                        {
                            if (strict) throw new EngineError(name + ": family " + fam + " is split");
                            shapeOk = false;
                        }
                        famSeen.Add(fam);
                        cur = fam;
                        buf = new List<int>();
                        nxt = 0;
                    }
                    if (idx != nxt)
                    {
                        if (strict) throw new EngineError(name + ": " + fam + " index " + idx.ToString(U.Inv) + " out of order");
                        shapeOk = false;
                    }
                    if (keepValues) buf.Add((int)val);
                    nxt++;
                }
                p = v + 3;
            }
            if (cur != null) { s.Fam[cur] = keepValues ? buf.ToArray() : null; s.FamOrder.Add(cur); }
            if (!shapeOk && strict) throw new EngineError(name + ": payload has lines that are not set statements");
            s.Lines = lines;
            s.L1 = l1;
            string hl, hl1;
            s.Head.TryGetValue("LB_PAYLOAD_LINES", out hl);
            s.Head.TryGetValue("LB_L1_CHECKSUM", out hl1);
            s.LinesOk = shapeOk && hl != null && lines.ToString(U.Inv) == hl;
            s.L1Ok = hl1 != null && l1.ToString(U.Inv) == hl1;
            if (strict && !s.LinesOk) throw new EngineError(name + ": payload line count differs from its header");
            if (strict && !s.L1Ok) throw new EngineError(name + ": L1 checksum differs");
            long l1slack = 0;
            if (hl != null && hl1 != null)
            {
                long ln = long.Parse(hl, U.Inv);
                if (ln >= (1L << 32)) throw new EngineError(name + ": too many payload lines");
                string maxL1 = (ln * 2147483648L).ToString(U.Inv);
                l1slack = Math.Max(0, maxL1.Length - hl1.Length);
            }
            s.BoundAnyValues = data.Length + slack + l1slack;
            return s;
        }
    }

    /// <summary>Weight-set manifests (LB-DOC/1 JSON) and their SHA512SUMS lists.</summary>
    public static class SetFiles
    {
        public const string ManifestFile = "manifest.cmd", SumsFile = "SHA512SUMS.cmd";

        public static string SetTable(List<object> shards)
        {
            var sb = new StringBuilder();
            foreach (object o in shards) { var s = (JObj)o; sb.Append(s.Str("file")).Append(' ').Append(s.Str("sha512")).Append('\n'); }
            return sb.ToString();
        }

        public static JObj WriteManifest(string dir, JObj meta, List<JObj> shards)
        {
            var list = new List<object>();
            foreach (var s in shards) list.Add(s);
            string table = SetTable(list);
            string cat;
            using (var h = U.NewSha512())
            {
                foreach (var s in shards)
                {
                    byte[] b = File.ReadAllBytes(Path.Combine(dir, s.Str("file")));
                    h.TransformBlock(b, 0, b.Length, null, 0);
                }
                h.TransformFinalBlock(new byte[0], 0, 0);
                cat = U.Hex(h.Hash);
            }
            long total = 0;
            foreach (var s in shards) total += s.Long("bytes");
            var m = new JObj();
            foreach (string k in meta.Keys) m[k] = meta[k];
            m["format"] = "LB-CMD/1";
            m["shards"] = list;
            m["set_sha512"] = U.Sha512Text(table);
            m["concatenated_sha512"] = cat;
            m["total_bytes"] = total;
            m["set_rule"] = "set_sha512 = SHA-512 of the lines '<file> <sha512>\\n' in shard order";
            Doc.WriteJson(Path.Combine(dir, ManifestFile), "manifest.json", m);
            var sums = new StringBuilder();
            foreach (var s in shards) sums.Append(s.Str("sha512")).Append("  ").Append(s.Str("file")).Append('\n');
            Doc.Write(Path.Combine(dir, SumsFile), "SHA512SUMS.txt", "sha512sums", U.Ascii.GetBytes(sums.ToString()), Doc.KindPrint);
            return m;
        }

        public static JObj ReadManifest(string path) { return (JObj)Doc.ReadJson(path); }

        public static Dictionary<string, string> ReadSums(string path)
        {
            var d = new Dictionary<string, string>(StringComparer.Ordinal);
            foreach (string line in Doc.ReadText(path).Split('\n'))
            {
                string t = line.Trim();
                if (t.Length == 0) continue;
                int sp = t.IndexOf("  ", StringComparison.Ordinal);
                if (sp < 0) throw new EngineError("SHA512SUMS: bad line");
                d[t.Substring(sp + 2)] = t.Substring(0, sp);
            }
            return d;
        }
    }

    /// <summary>tools\LB_CMD.cmd: verification of sets and combined manifests (verify_weights.py and lb_cmd.py verify).</summary>
    public static class Verify
    {
        public static JObj CheckSet(string manifestPath, long? cap, long? totalCap, string pin, bool bound)
        {
            manifestPath = Path.GetFullPath(manifestPath);
            string d = Path.GetDirectoryName(manifestPath);
            var m = SetFiles.ReadManifest(manifestPath);
            var sums = SetFiles.ReadSums(Path.Combine(d, SetFiles.SumsFile));
            var rows = new List<object>();
            long total = 0, boundTotal = 0, maxBytes = 0, maxBound = 0;
            bool every = true;
            string cat;
            var files = new HashSet<string>(StringComparer.Ordinal);
            using (var h = U.NewSha512())
            {
                foreach (object o in m.Arr("shards"))
                {
                    var s = (JObj)o;
                    string f = s.Str("file");
                    files.Add(f);
                    byte[] data = File.ReadAllBytes(Path.Combine(d, f));
                    h.TransformBlock(data, 0, data.Length, null, 0);
                    string fh = U.Sha512Hex(data);
                    var sd = ShardData.Parse(data, f, false, false);
                    total += data.Length;
                    boundTotal += sd.BoundAnyValues;
                    maxBytes = Math.Max(maxBytes, data.Length);
                    maxBound = Math.Max(maxBound, sd.BoundAnyValues);
                    string sumv;
                    sums.TryGetValue(f, out sumv);
                    var r = new JObj();
                    r["file"] = f;
                    r["bytes"] = (long)data.Length;
                    r["sha512_ok"] = fh == s.Str("sha512");
                    r["sums_ok"] = sumv == fh;
                    r["size_ok"] = data.Length == s.Long("bytes") && (cap == null || data.Length <= cap.Value);
                    r["bytes_bound_any_values"] = sd.BoundAnyValues;
                    r["payload_sha512_ok"] = sd.PayloadShaOk && sd.PayloadSha512 == s.Str("payload_sha512");
                    r["payload_lines_ok"] = sd.LinesOk && sd.Lines == s.Long("payload_lines");
                    r["l1_ok"] = sd.L1Ok && sd.L1 == s.Long("l1_checksum");
                    string fmt, tier;
                    sd.Head.TryGetValue("LB_FORMAT", out fmt);
                    sd.Head.TryGetValue("LB_TIER", out tier);
                    r["format"] = fmt;
                    r["tier"] = tier;
                    r["bound_ok"] = !bound || cap == null || sd.BoundAnyValues <= cap.Value;
                    bool ok = true;
                    foreach (string k in new[] { "sha512_ok", "sums_ok", "size_ok", "payload_sha512_ok", "payload_lines_ok", "l1_ok", "bound_ok" }) ok &= (bool)r[k];
                    r["ok"] = ok;
                    every &= ok;
                    rows.Add(r);
                }
                h.TransformFinalBlock(new byte[0], 0, 0);
                cat = U.Hex(h.Hash);
            }
            var res = new JObj();
            res["manifest"] = Path.GetFileName(manifestPath);
            res["model"] = m.Get("model");
            res["tier"] = m.Get("tier");
            res["shards"] = (long)rows.Count;
            res["total_bytes"] = total;
            res["max_shard_bytes"] = maxBytes;
            res["every_shard_ok"] = every;
            res["total_bytes_bound_any_values"] = boundTotal;
            res["max_shard_bytes_bound_any_values"] = maxBound;
            res["sums_file_lists_exactly_the_shards"] = sums.Count == files.Count && files.All(sums.ContainsKey);
            res["set_sha512"] = m.Str("set_sha512");
            res["set_sha512_ok"] = U.Sha512Text(SetFiles.SetTable(m.Arr("shards"))) == m.Str("set_sha512");
            res["concatenated_sha512_ok"] = cat == m.Str("concatenated_sha512");
            res["cap"] = cap.HasValue ? (object)cap.Value : null;
            res["total_cap"] = totalCap.HasValue ? (object)totalCap.Value : null;
            res["total_ok"] = total == m.Long("total_bytes") && (totalCap == null || total <= totalCap.Value) &&
                              (!bound || totalCap == null || boundTotal <= totalCap.Value);
            res["pinned_set_ok"] = pin == null ? null : (object)(pin == m.Str("set_sha512"));
            res["rows"] = rows;
            bool all = every && (bool)res["sums_file_lists_exactly_the_shards"] && (bool)res["set_sha512_ok"] &&
                       (bool)res["concatenated_sha512_ok"] && (bool)res["total_ok"] && !(pin != null && !(bool)res["pinned_set_ok"]);
            res["all_pass"] = all;
            return res;
        }

        public static JObj CheckCombined(string path, long? cap, long? totalCap)
        {
            path = Path.GetFullPath(path);
            string b = Path.GetDirectoryName(path);
            var c = (JObj)Doc.ReadJson(path);
            var sets = new List<JObj>();
            var table = new StringBuilder();
            long aux = 0, n = 0, now = 0, bound = 0;
            var nominal = new JObj();
            foreach (object o in c.Arr("sets"))
            {
                var s = (JObj)o;
                string folder = s.Str("folder");
                string mpath = Path.Combine(b, folder.Replace('/', Path.DirectorySeparatorChar), SetFiles.ManifestFile);
                var r = CheckSet(mpath, cap, null, s.Str("set_sha512"), true);
                r["folder"] = folder;
                sets.Add(r);
                table.Append(folder).Append(' ').Append(s.Str("set_sha512")).Append('\n');
                foreach (string f in new[] { SetFiles.ManifestFile, SetFiles.SumsFile })
                    aux += new FileInfo(Path.Combine(Path.GetDirectoryName(mpath), f)).Length;
                n += r.Long("shards");
                now += r.Long("total_bytes");
                bound += r.Long("total_bytes_bound_any_values");
                nominal[folder] = s.Get("nominal_parameters");
            }
            long self = new FileInfo(path).Length;
            now += aux + self;
            bound += aux + 16 * n + self;
            var res = new JObj();
            res["combined_manifest"] = Path.GetFileName(path);
            var brief = new List<object>();
            foreach (var r in sets)
            {
                var x = new JObj();
                foreach (string k in new[] { "folder", "manifest", "model", "tier", "shards", "total_bytes", "total_bytes_bound_any_values", "max_shard_bytes_bound_any_values", "all_pass" })
                    x[k] = r.Get(k);
                brief.Add(x);
            }
            res["sets"] = brief;
            res["combined_sha512_ok"] = U.Sha512Text(table.ToString()) == c.Str("combined_sha512");
            res["all_files_bytes_now"] = now;
            res["all_files_bytes_bound_any_values"] = bound;
            res["cap"] = cap.HasValue ? (object)cap.Value : null;
            res["total_cap"] = totalCap.HasValue ? (object)totalCap.Value : null;
            res["within_total_cap_now_and_after_any_training"] = totalCap == null || bound <= totalCap.Value;
            res["nominal_parameters"] = nominal;
            bool all = (bool)res["combined_sha512_ok"] && (bool)res["within_total_cap_now_and_after_any_training"];
            foreach (var r in sets) all &= (bool)r["all_pass"];
            res["all_pass"] = all;
            return res;
        }
    }

    // ======== 04_doc.cs ========
    /// <summary>
    /// LB-DOC/1: a document (JSON, text, Markdown, an LCUF-X program, a SHA512SUMS list) stored in a .cmd file. The document
    /// is the last LB_DOC_BYTES bytes of the file, after the line "rem ---- document ----"; LB_DOC_SHA512 is its SHA-512.
    /// The header before it is a short cmd script: cmd.exe stops at "exit /b", so it never reads the document.
    /// </summary>
    public static class Doc
    {
        public const string Marker = "rem ---- document ----\r\n";
        public const string KindPrint = "print", KindKgd = "kgd-program", KindCore = "core-program", KindReason = "reason:";

        const string PrintScript =
            "powershell -NoProfile -ExecutionPolicy Bypass -Command \"$n=[int]$env:LB_DOC_BYTES;$b=[IO.File]::ReadAllBytes($env:LB_SELF);" +
            "$o=$b.Length-$n;$h=-join((New-Object Security.Cryptography.SHA512Managed).ComputeHash($b,$o,$n)|%%{$_.ToString('x2')});" +
            "if($h -ne $env:LB_DOC_SHA512){[Console]::Error.WriteLine('LB-DOC/1: the SHA-512 of '+$env:LB_DOC+' differs from LB_DOC_SHA512');exit 1};" +
            "if($env:LB_ARG -eq '/check'){'ok: '+$env:LB_DOC;exit 0};" +
            "if($env:LB_ARG -eq '/extract'){$d=New-Object byte[] $n;[Array]::Copy($b,$o,$d,0,$n);[IO.File]::WriteAllBytes($env:LB_OUT,$d);'written: '+$env:LB_OUT;exit 0};" +
            "[Console]::OutputEncoding=New-Object Text.UTF8Encoding $false;[Console]::Out.Write([Text.Encoding]::UTF8.GetString($b,$o,$n));exit 0\"";

        public static byte[] Pack(string name, string type, byte[] payload, string kind)
        {
            var h = new List<string>();
            h.Add("@echo off");
            h.Add("setlocal EnableExtensions DisableDelayedExpansion");
            h.Add("rem LK/Vexa .cmd document (LB-DOC/1): " + name + ". The document is the last LB_DOC_BYTES bytes of this file.");
            if (kind == KindKgd)
                h.Add("rem Run it to run the program on this package's host, lcufx\\LCUFX_KGD.cmd (run --twice); or pass check or run.");
            else if (kind == KindCore)
                h.Add("rem It runs on your LCUF-X/0.2 compiler (lcuf_x.py) through tools\\RUN_CORE.cmd: see README.md.");
            else if (kind.StartsWith(KindReason, StringComparison.Ordinal))
                h.Add("rem Run it to run the reasoning layer on it (tools\\REASON.cmd " + kind.Substring(KindReason.Length) + "); tools\\DOC.cmd print shows the spec.");
            else
                h.Add("rem Run it to print the document, with /check to check its SHA-512, or with /extract FILE to write it out.");
            h.Add("set \"LB_FORMAT=LB-DOC/1\"");
            h.Add("set \"LB_DOC=" + name + "\"");
            h.Add("set \"LB_DOC_TYPE=" + type + "\"");
            h.Add("set \"LB_DOC_BYTES=" + payload.Length.ToString(U.Inv) + "\"");
            h.Add("set \"LB_DOC_SHA512=" + U.Sha512Hex(payload) + "\"");
            if (kind == KindKgd)
            {
                h.Add("set \"LB_HOST=%~dp0..\\..\\LCUFX_KGD.cmd\"");
                h.Add("if \"%~1\"==\"\" call \"%LB_HOST%\" run \"%~f0\" --twice");
                h.Add("if not \"%~1\"==\"\" call \"%LB_HOST%\" %1 \"%~f0\" %2 %3");
                h.Add("set \"LB_RC=%errorlevel%\"");
                h.Add("if \"%~1\"==\"\" pause");
            }
            else if (kind.StartsWith(KindReason, StringComparison.Ordinal))
            {
                string rop = kind.Substring(KindReason.Length);
                if (!Regex.IsMatch(rop, "^[a-z]+\\z")) throw new EngineError("LB-DOC/1: bad reasoning operation " + rop);
                h.Add("set \"LB_REASON=%~dp0..\\tools\\REASON.cmd\"");
                h.Add("call \"%LB_REASON%\" " + rop + " \"%~f0\" %1 %2");
                h.Add("set \"LB_RC=%errorlevel%\"");
                h.Add("if \"%~1\"==\"\" pause");
            }
            else if (kind == KindCore)
            {
                h.Add("set \"LB_CORE=%~dp0..\\..\\..\\tools\\RUN_CORE.cmd\"");
                h.Add("if \"%~1\"==\"\" call \"%LB_CORE%\" run \"%~f0\"");
                h.Add("if not \"%~1\"==\"\" call \"%LB_CORE%\" %1 \"%~f0\" %2 %3");
                h.Add("set \"LB_RC=%errorlevel%\"");
                h.Add("if \"%~1\"==\"\" pause");
            }
            else
            {
                h.Add("set \"LB_SELF=%~f0\"");
                h.Add("set \"LB_ARG=%~1\"");
                h.Add("set \"LB_OUT=%~f2\"");
                h.Add(PrintScript);
                h.Add("set \"LB_RC=%errorlevel%\"");
                h.Add("if \"%LB_ARG%\"==\"\" pause");
            }
            h.Add("exit /b %LB_RC%");
            string head = string.Join(U.CRLF, h) + U.CRLF + Marker;
            byte[] hb = U.Ascii.GetBytes(head);
            if (U.Ascii.GetString(hb) != head) throw new EngineError("LB-DOC/1: the name must be ASCII: " + name);
            var all = new byte[hb.Length + payload.Length];
            Buffer.BlockCopy(hb, 0, all, 0, hb.Length);
            Buffer.BlockCopy(payload, 0, all, hb.Length, payload.Length);
            return all;
        }

        public static void Write(string path, string name, string type, byte[] payload, string kind)
        {
            U.WriteBytes(path, Pack(name, type, payload, kind));
        }

        public static void WriteJson(string path, string name, object value)
        {
            Write(path, name, "json", U.Utf8.GetBytes(Json.Dump(value, 1, true)), KindPrint);
        }

        public static void WriteText(string path, string name, string type, string text)
        {
            Write(path, name, type, U.Utf8.GetBytes(text), KindPrint);
        }

        public class Info
        {
            public string Name, Type;
            public long Bytes;
            public string Sha512;
            public byte[] Payload;
            public bool Ok;
            public string Error;
        }

        public static Info Inspect(byte[] all)
        {
            var info = new Info();
            byte[] mk = U.Ascii.GetBytes(Marker);
            int m = U.IndexOf(all, mk, 0);
            if (m < 0) { info.Error = "no LB-DOC/1 marker line"; return info; }
            string head = U.Ascii.GetString(all, 0, m);
            foreach (string line in head.Split(new[] { "\r\n" }, StringSplitOptions.None))
            {
                if (!line.StartsWith("set \"", StringComparison.Ordinal) || !line.EndsWith("\"", StringComparison.Ordinal)) continue;
                string kv = line.Substring(5, line.Length - 6);
                int eq = kv.IndexOf('=');
                if (eq < 0) continue;
                string k = kv.Substring(0, eq), v = kv.Substring(eq + 1);
                if (k == "LB_DOC") info.Name = v;
                else if (k == "LB_DOC_TYPE") info.Type = v;
                else if (k == "LB_DOC_BYTES") info.Bytes = long.Parse(v, U.Inv);
                else if (k == "LB_DOC_SHA512") info.Sha512 = v;
            }
            if (!head.Contains("set \"LB_FORMAT=LB-DOC/1\"")) { info.Error = "not an LB-DOC/1 file"; return info; }
            int start = m + mk.Length;
            if (start + info.Bytes != all.Length) { info.Error = "LB_DOC_BYTES does not reach the end of the file"; return info; }
            info.Payload = new byte[info.Bytes];
            Buffer.BlockCopy(all, start, info.Payload, 0, (int)info.Bytes);
            if (U.Sha512Hex(info.Payload) != info.Sha512) { info.Error = "the document's SHA-512 differs from LB_DOC_SHA512"; return info; }
            info.Ok = true;
            return info;
        }

        public static byte[] Read(string path)
        {
            var info = Inspect(File.ReadAllBytes(path));
            if (!info.Ok) throw new EngineError(Path.GetFileName(path) + ": " + info.Error);
            return info.Payload;
        }

        public static string ReadText(string path)
        {
            byte[] p = Read(path);
            int skip = (p.Length >= 3 && p[0] == 0xEF && p[1] == 0xBB && p[2] == 0xBF) ? 3 : 0;
            return U.Utf8.GetString(p, skip, p.Length - skip);
        }

        public static object ReadJson(string path) { return Json.Parse(ReadText(path)); }
    }

    // ======== 05_dense.cs ========
    /// <summary>A model configuration (kgd_model.config, gen_model2.config).</summary>
    public sealed class Cfg
    {
        public int Vocab, D, Layers, Heads, Kv, Dk, Dff, SeqLen, EmbClusters, EmbClusterRows;
        public double RopeBase = 10000.0, AlphaInit = 0.05, CInit = 1.0;
        public bool Kgd = true;
        public JObj Json;

        public int KvSize { get { return Kv * Dk; } }

        public static Cfg Make(int vocab, int d, int layers, int heads, int kv, int dff, int seq, double alpha, double c, bool kgd)
        {
            if (d % heads != 0 || heads % kv != 0 || (d / heads) % 2 != 0) throw new EngineError("inconsistent configuration");
            var g = new Cfg { Vocab = vocab, D = d, Layers = layers, Heads = heads, Kv = kv, Dk = d / heads, Dff = dff, SeqLen = seq, AlphaInit = alpha, CInit = c, Kgd = kgd };
            var j = new JObj();
            j["vocab"] = (long)vocab; j["d"] = (long)d; j["n_layers"] = (long)layers; j["n_heads"] = (long)heads; j["n_kv"] = (long)kv;
            j["d_k"] = (long)(d / heads); j["d_ff"] = (long)dff; j["seq_len"] = (long)seq; j["rope_base"] = 10000.0;
            j["alpha_init"] = alpha; j["c_init"] = c; j["kgd"] = kgd;
            g.Json = j;
            return g;
        }

        public static Cfg FromJson(JObj j)
        {
            var g = new Cfg();
            g.Vocab = (int)j.Long("vocab"); g.D = (int)j.Long("d"); g.Layers = (int)j.Long("n_layers"); g.Heads = (int)j.Long("n_heads");
            g.Kv = (int)j.Long("n_kv"); g.Dk = (int)j.Long("d_k"); g.Dff = (int)j.Long("d_ff"); g.SeqLen = (int)j.Long("seq_len");
            if (j.Has("rope_base")) g.RopeBase = j.Dbl("rope_base");
            if (j.Has("alpha_init")) g.AlphaInit = j.Dbl("alpha_init");
            if (j.Has("c_init")) g.CInit = j.Dbl("c_init");
            if (j.Has("kgd")) g.Kgd = (bool)j["kgd"];
            if (j.Has("emb_clusters")) g.EmbClusters = (int)j.Long("emb_clusters");
            if (j.Has("emb_cluster_rows")) g.EmbClusterRows = (int)j.Long("emb_cluster_rows");
            g.Json = j;
            return g;
        }
    }

    /// <summary>Named float32 tensors in a fixed order (a parameter dict).</summary>
    public sealed class Params
    {
        public readonly List<string> Names = new List<string>();
        public readonly Dictionary<string, float[]> T = new Dictionary<string, float[]>(StringComparer.Ordinal);
        public readonly Dictionary<string, int[]> Shape = new Dictionary<string, int[]>(StringComparer.Ordinal);

        public float[] this[string k] { get { float[] v; if (!T.TryGetValue(k, out v)) throw new EngineError("tensor " + k + " missing"); return v; } }
        public bool Has(string k) { return T.ContainsKey(k); }

        public void Add(string name, int[] shape, float[] v)
        {
            if (!T.ContainsKey(name)) Names.Add(name);
            T[name] = v;
            Shape[name] = shape;
        }

        public Params ZerosLike()
        {
            var p = new Params();
            foreach (string n in Names) p.Add(n, Shape[n], new float[T[n].Length]);
            return p;
        }

        public long Count { get { long s = 0; foreach (var v in T.Values) s += v.Length; return s; } }
    }

    /// <summary>Shared numeric kernels (double arithmetic, float32 parameters), deterministic under parallelism.</summary>
    public static class Prim
    {
        public const double EpsF32 = 1.1920928955078125e-07, EpsF64 = 2.220446049250313e-16;
        static readonly ParallelOptions Par = new ParallelOptions { MaxDegreeOfParallelism = Environment.ProcessorCount };

        public static void For(int n, long work, Action<int> body)
        {
            if (n <= 1 || work < 200000) { for (int i = 0; i < n; i++) body(i); return; }
            Parallel.For(0, n, Par, body);
        }

        public static double[] ToF32(double[] x)
        {
            for (int i = 0; i < x.Length; i++) x[i] = (float)x[i];
            return x;
        }

        /// <summary>Y[n, r] = sum_k X[n, k] W[(r0 + r) K + k]  (x @ W[r0:r0+R].T).</summary>
        public static double[] XWt(double[] X, int N, int K, float[] W, int r0, int R)
        {
            var Y = new double[N * R];
            For(R, (long)N * K * R, r =>
            {
                int wo = (r0 + r) * K;
                for (int n = 0; n < N; n++)
                {
                    int xo = n * K;
                    double s0 = 0, s1 = 0, s2 = 0, s3 = 0;
                    int k = 0;
                    for (; k + 3 < K; k += 4)
                    {
                        s0 += X[xo + k] * W[wo + k]; s1 += X[xo + k + 1] * W[wo + k + 1];
                        s2 += X[xo + k + 2] * W[wo + k + 2]; s3 += X[xo + k + 3] * W[wo + k + 3];
                    }
                    for (; k < K; k++) s0 += X[xo + k] * W[wo + k];
                    Y[n * R + r] = (s0 + s1) + (s2 + s3);
                }
            });
            return Y;
        }

        /// <summary>Y[n, k] = sum_r Dy[n, r] W[(r0 + r) K + k]  (dy @ W[r0:r0+R]).</summary>
        public static double[] DyW(double[] Dy, int N, int R, float[] W, int r0, int K)
        {
            var Y = new double[N * K];
            For(N, (long)N * K * R, n =>
            {
                int yo = n * K, dyo = n * R;
                for (int r = 0; r < R; r++)
                {
                    double d = Dy[dyo + r];
                    if (d == 0) continue;
                    int wo = (r0 + r) * K;
                    for (int k = 0; k < K; k++) Y[yo + k] += d * W[wo + k];
                }
            });
            return Y;
        }

        /// <summary>G[(r0 + r) K + k] += sum_n Dy[n, r] X[n, k]  (dy.T @ x into a float32 gradient).</summary>
        public static void AccDtX(double[] Dy, int N, int R, double[] X, int K, float[] G, int r0)
        {
            For(R, (long)N * K * R, r =>
            {
                var acc = new double[K];
                bool any = false;
                for (int n = 0; n < N; n++)
                {
                    double d = Dy[n * R + r];
                    if (d == 0) continue;
                    any = true;
                    int xo = n * K;
                    for (int k = 0; k < K; k++) acc[k] += d * X[xo + k];
                }
                if (!any) return;
                int go = (r0 + r) * K;
                for (int k = 0; k < K; k++) G[go + k] = (float)(G[go + k] + acc[k]);
            });
        }

        public static double[] RmsNorm(double[] x, int N, int D, float[] w, double eps, double[] xhOut, double[] rOut)
        {
            var y = new double[N * D];
            for (int n = 0; n < N; n++)
            {
                int o = n * D;
                double ss = 0;
                for (int j = 0; j < D; j++) ss += x[o + j] * x[o + j];
                double r = 1.0 / Math.Sqrt(ss / D + eps);
                if (rOut != null) rOut[n] = r;
                for (int j = 0; j < D; j++)
                {
                    double xh = x[o + j] * r;
                    if (xhOut != null) xhOut[o + j] = xh;
                    y[o + j] = xh * w[j];
                }
            }
            return y;
        }

        public static double[] RmsNormB(double[] dy, int N, int D, double[] xh, double[] r, float[] w, double[] dw)
        {
            var dx = new double[N * D];
            for (int n = 0; n < N; n++)
            {
                int o = n * D;
                double m = 0;
                for (int j = 0; j < D; j++) { double g = dy[o + j] * w[j]; m += g * xh[o + j]; dw[j] += dy[o + j] * xh[o + j]; }
                m /= D;
                for (int j = 0; j < D; j++) dx[o + j] = r[n] * (dy[o + j] * w[j] - xh[o + j] * m);
            }
            return dx;
        }

        public static void RopeTables(int T, int dk, double baseV, bool f32, out double[] cos, out double[] sin)
        {
            int half = dk / 2;
            cos = new double[T * half];
            sin = new double[T * half];
            var theta = new double[half];
            for (int i = 0; i < half; i++) theta[i] = 1.0 / Math.Pow(baseV, (2.0 * i) / dk);
            for (int t = 0; t < T; t++)
                for (int i = 0; i < half; i++)
                {
                    double a = t * theta[i];
                    double c = Math.Cos(a), s = Math.Sin(a);
                    cos[t * half + i] = f32 ? (float)c : c;
                    sin[t * half + i] = f32 ? (float)s : s;
                }
        }

        /// <summary>x [N, H, dk] with position t = n mod T; interleaved pairs as torchtune's RotaryPositionalEmbeddings.</summary>
        public static void Rope(double[] x, int N, int T, int H, int dk, double[] cos, double[] sin, bool backward)
        {
            int half = dk / 2;
            for (int n = 0; n < N; n++)
            {
                int t = n % T;
                for (int h = 0; h < H; h++)
                {
                    int o = (n * H + h) * dk;
                    for (int i = 0; i < half; i++)
                    {
                        double c = cos[t * half + i], s = sin[t * half + i];
                        double a = x[o + 2 * i], b = x[o + 2 * i + 1];
                        if (!backward) { x[o + 2 * i] = a * c - b * s; x[o + 2 * i + 1] = b * c + a * s; }
                        else { x[o + 2 * i] = a * c + b * s; x[o + 2 * i + 1] = -a * s + b * c; }
                    }
                }
            }
        }

        /// <summary>Causal GQA attention core. Q [B*T, H, dk], K and V [B*T, KV, dk]; returns O [B*T, H*dk] and A [B, H, T, T].</summary>
        public static double[] AttnCore(double[] Q, double[] K, double[] V, int B, int T, int H, int KV, int dk, double[] Aout)
        {
            int g = H / KV;
            var O = new double[B * T * H * dk];
            double scale = 1.0 / Math.Sqrt(dk);
            For(B * H, (long)B * H * T * T * dk, bh =>
            {
                int b = bh / H, h = bh % H, kvh = h / g;
                var S = new double[T];
                for (int t = 0; t < T; t++)
                {
                    int qo = ((b * T + t) * H + h) * dk;
                    double mx = double.NegativeInfinity;
                    bool nan = false;
                    for (int s = 0; s <= t; s++)
                    {
                        int ko = ((b * T + s) * KV + kvh) * dk;
                        double acc = 0;
                        for (int j = 0; j < dk; j++) acc += Q[qo + j] * K[ko + j];
                        S[s] = acc * scale;
                        if (double.IsNaN(S[s])) nan = true; else if (S[s] > mx) mx = S[s];
                    }
                    if (nan) mx = double.NaN;
                    double z = 0;
                    for (int s = 0; s <= t; s++) { S[s] = Math.Exp(S[s] - mx); z += S[s]; }
                    int oo = (b * T + t) * H * dk + h * dk;
                    for (int s = 0; s <= t; s++)
                    {
                        double a = S[s] / z;
                        if (Aout != null) Aout[((b * H + h) * T + t) * T + s] = a;
                        int vo = ((b * T + s) * KV + kvh) * dk;
                        for (int j = 0; j < dk; j++) O[oo + j] += a * V[vo + j];
                    }
                }
            });
            return O;
        }

        /// <summary>The KGD-IMQ step on h [B*T, d]: (1 - alpha) h + alpha D^-1 K h with the causal IMQ kernel.</summary>
        public static double[] Kgd(double[] h, int B, int T, int d, double alpha, double c, double eps, KgdCache cache)
        {
            var y = new double[h.Length];
            var z = new double[h.Length];
            var r = new double[B * T];
            var Km = new double[B * T * T];
            var ssum = new double[B * T];
            var Ph = new double[h.Length];
            for (int n = 0; n < B * T; n++)
            {
                double ss = 0;
                for (int j = 0; j < d; j++) ss += h[n * d + j] * h[n * d + j];
                r[n] = 1.0 / Math.Sqrt(ss / d + eps);
                for (int j = 0; j < d; j++) z[n * d + j] = h[n * d + j] * r[n];
            }
            For(B, (long)B * T * T * d, b =>
            {
                var nrm = new double[T];
                for (int t = 0; t < T; t++)
                {
                    double s = 0;
                    int o = (b * T + t) * d;
                    for (int j = 0; j < d; j++) s += z[o + j] * z[o + j];
                    nrm[t] = s;
                }
                for (int t = 0; t < T; t++)
                {
                    int to = (b * T + t) * d;
                    double sum = 0;
                    for (int s = 0; s <= t; s++)
                    {
                        int so = (b * T + s) * d;
                        double G = 0;
                        for (int j = 0; j < d; j++) G += z[to + j] * z[so + j];
                        double D2 = Math.Max(nrm[t] + nrm[s] - 2.0 * G, 0.0) / d;
                        double k = 1.0 / Math.Sqrt(c * c + D2);
                        Km[(b * T + t) * T + s] = k;
                        sum += k;
                    }
                    ssum[b * T + t] = sum;
                    for (int s = 0; s <= t; s++)
                    {
                        double p = Km[(b * T + t) * T + s] / sum;
                        int so = (b * T + s) * d;
                        for (int j = 0; j < d; j++) Ph[to + j] += p * h[so + j];
                    }
                    for (int j = 0; j < d; j++) y[to + j] = (1.0 - alpha) * h[to + j] + alpha * Ph[to + j];
                }
            });
            if (cache != null)
            {
                cache.H = h; cache.Z = z; cache.R = r; cache.K = Km; cache.S = ssum; cache.Ph = Ph;
                cache.Alpha = alpha; cache.C = c; cache.B = B; cache.T = T; cache.D = d;
            }
            return y;
        }

        public static double[] KgdB(double[] dy, KgdCache k, out double dalpha, out double dc)
        {
            int B = k.B, T = k.T, d = k.D;
            double alpha = k.Alpha, c = k.C;
            var dh = new double[dy.Length];
            double da = 0, dcc = 0;
            for (int i = 0; i < dy.Length; i++) { dh[i] = (1.0 - alpha) * dy[i]; da += dy[i] * (k.Ph[i] - k.H[i]); }
            var dz = new double[dy.Length];
            for (int b = 0; b < B; b++)
            {
                var P = new double[T * T];
                for (int t = 0; t < T; t++) for (int s = 0; s <= t; s++) P[t * T + s] = k.K[(b * T + t) * T + s] / k.S[b * T + t];
                for (int t = 0; t < T; t++)
                {
                    int to = (b * T + t) * d;
                    for (int s = 0; s <= t; s++)
                    {
                        int so = (b * T + s) * d;
                        double p = alpha * P[t * T + s];
                        for (int j = 0; j < d; j++) dh[so + j] += p * dy[to + j];
                    }
                }
                var dS = new double[T * T];
                var dn = new double[T];
                for (int t = 0; t < T; t++)
                {
                    int to = (b * T + t) * d;
                    var dP = new double[t + 1];
                    double dot = 0;
                    for (int s = 0; s <= t; s++)
                    {
                        int so = (b * T + s) * d;
                        double acc = 0;
                        for (int j = 0; j < d; j++) acc += dy[to + j] * k.H[so + j];
                        dP[s] = alpha * acc;
                        dot += dP[s] * P[t * T + s];
                    }
                    double st = k.S[b * T + t];
                    for (int s = 0; s <= t; s++)
                    {
                        double dK = (dP[s] - dot) / st;
                        double kv = k.K[(b * T + t) * T + s];
                        double k3 = kv * kv * kv;
                        double dD2 = -0.5 * k3 * dK;
                        dcc += -c * k3 * dK;
                        dS[t * T + s] = dD2 / d;
                    }
                }
                for (int t = 0; t < T; t++)
                    for (int s = 0; s < T; s++) { dn[t] += dS[t * T + s]; dn[s] += dS[t * T + s]; }
                for (int t = 0; t < T; t++)
                {
                    int to = (b * T + t) * d;
                    for (int s = 0; s < T; s++)
                    {
                        double gsum = -2.0 * dS[t * T + s] - 2.0 * dS[s * T + t];
                        if (gsum == 0) continue;
                        int so = (b * T + s) * d;
                        for (int j = 0; j < d; j++) dz[to + j] += gsum * k.Z[so + j];
                    }
                    for (int j = 0; j < d; j++) dz[to + j] += 2.0 * dn[t] * k.Z[to + j];
                }
            }
            for (int n = 0; n < B * T; n++)
            {
                int o = n * d;
                double m = 0;
                for (int j = 0; j < d; j++) m += dz[o + j] * k.Z[o + j];
                m /= d;
                for (int j = 0; j < d; j++) dh[o + j] += k.R[n] * (dz[o + j] - k.Z[o + j] * m);
            }
            dalpha = da;
            dc = dcc;
            return dh;
        }

        public static void KgdValues(float a, float b, out double alpha, out double c)
        {
            alpha = 0.5 / (1.0 + Math.Exp(-(double)a));
            c = FdLibm.Softplus(b);
        }
    }

    public sealed class KgdCache
    {
        public double[] H, Z, R, K, S, Ph;
        public double Alpha, C;
        public int B, T, D;
    }

    // ======== 05b_model.cs ========
    /// <summary>kgd_model.py: the KGD-IMQ 5-Dollar LLM (dense float32 parameters, double arithmetic).</summary>
    public static class Model
    {
        public static List<KeyValuePair<string, int[]>> Shapes(Cfg c)
        {
            var s = new List<KeyValuePair<string, int[]>>();
            int d = c.D, dk = c.Dk, kv = c.KvSize;
            s.Add(new KeyValuePair<string, int[]>("emb", new[] { c.Vocab, d }));
            for (int l = 0; l < c.Layers; l++)
            {
                string p = Lp(l);
                s.Add(new KeyValuePair<string, int[]>(p + "n1", new[] { d }));
                s.Add(new KeyValuePair<string, int[]>(p + "qkvo", new[] { d + 2 * kv + d, d }));
                s.Add(new KeyValuePair<string, int[]>(p + "qn", new[] { dk }));
                s.Add(new KeyValuePair<string, int[]>(p + "kn", new[] { dk }));
                s.Add(new KeyValuePair<string, int[]>(p + "n2", new[] { d }));
                s.Add(new KeyValuePair<string, int[]>(p + "up", new[] { c.Dff, d }));
                s.Add(new KeyValuePair<string, int[]>(p + "down", new[] { d, c.Dff }));
                if (c.Kgd)
                {
                    s.Add(new KeyValuePair<string, int[]>(p + "ka", new int[0]));
                    s.Add(new KeyValuePair<string, int[]>(p + "kb", new int[0]));
                }
            }
            s.Add(new KeyValuePair<string, int[]>("fn", new[] { d }));
            return s;
        }

        public static string Lp(int l) { return "L" + l.ToString("00", U.Inv) + "."; }

        public static long Size(int[] shape) { long n = 1; foreach (int x in shape) n *= x; return n; }

        public static long NParams(Cfg c) { long n = 0; foreach (var kv in Shapes(c)) n += Size(kv.Value); return n; }

        public static string Last(string name) { int i = name.LastIndexOf('.'); return i < 0 ? name : name.Substring(i + 1); }

        public static bool IsMuon(string name) { string k = Last(name); return k == "qkvo" || k == "up" || k == "down"; }

        /// <summary>init_params: N(0, 0.02^2) matrices from numpy's PCG64 seeded by SHA-512("seed:name"), ones for norms.</summary>
        public static Params Init(Cfg c, long seed)
        {
            var P = new Params();
            foreach (var kv in Shapes(c))
            {
                string name = kv.Key, key = Last(name);
                long n = Size(kv.Value);
                var v = new float[n];
                if (key == "n1" || key == "n2" || key == "qn" || key == "kn" || key == "fn")
                    for (long i = 0; i < n; i++) v[i] = 1f;
                else if (key == "ka") { double p = 2 * c.AlphaInit; v[0] = (float)Math.Log(p / (1 - p)); }
                else if (key == "kb") v[0] = (float)Math.Log(FdLibm.Expm1(c.CInit));
                else
                {
                    var g = Pcg64.FromText(seed.ToString(U.Inv) + ":" + name);
                    for (long i = 0; i < n; i++) v[i] = (float)(g.StandardNormal() * 0.02);
                }
                P.Add(name, kv.Value, v);
            }
            return P;
        }

        public static void Kgd(Params P, int l, out double alpha, out double c)
        {
            string p = Lp(l);
            Prim.KgdValues(P[p + "ka"][0], P[p + "kb"][0], out alpha, out c);
        }

        internal sealed class LayerCache
        {
            public double[] X1h, R1, N1, Qh, Qnr, Kh, Knr, Qrot, Krot, V, A, O, X2h, R2, N2, Rl, Act;
            public KgdCache Kc;
        }

        public sealed class Cache
        {
            internal int B, T;
            internal long[] Tokens, Targets;
            internal LayerCache[] Layers;
            internal double[] Hf, Fh, Fr, Probs, Cos, Sin;
            internal double Sd;
            internal bool F32;
        }

        /// <summary>forward(P, cfg, tokens [B,T], targets): returns logits [B*T, V]; loss is NaN when targets is null.</summary>
        public static double[] Forward(Params P, Cfg cfg, long[] tokens, int B, int T, long[] targets, bool f32, out double loss, Cache cache)
        {
            int d = cfg.D, H = cfg.Heads, KV = cfg.Kv, dk = cfg.Dk, kvs = cfg.KvSize, V = cfg.Vocab, N = B * T, w3 = d + 2 * kvs;
            double eps = f32 ? Prim.EpsF32 : Prim.EpsF64;
            double[] cos, sin;
            Prim.RopeTables(T, dk, cfg.RopeBase, f32, out cos, out sin);
            double sd = Math.Sqrt(d);
            float[] emb = P["emb"];
            var h = new double[N * d];
            for (int n = 0; n < N; n++)
            {
                long tk = tokens[n];
                if (tk < 0 || tk >= V) throw new EngineError("token out of range");
                for (int j = 0; j < d; j++) h[n * d + j] = emb[tk * d + j] * sd;
            }
            var lcs = new LayerCache[cfg.Layers];
            for (int l = 0; l < cfg.Layers; l++)
            {
                string p = Lp(l);
                var lc = new LayerCache();
                lc.X1h = new double[N * d]; lc.R1 = new double[N];
                lc.N1 = Prim.RmsNorm(h, N, d, P[p + "n1"], eps, lc.X1h, lc.R1);
                float[] W = P[p + "qkvo"];
                var qkv = Prim.XWt(lc.N1, N, d, W, 0, w3);
                var q = new double[N * d];
                var k = new double[N * kvs];
                var v = new double[N * kvs];
                for (int n = 0; n < N; n++)
                {
                    Array.Copy(qkv, n * w3, q, n * d, d);
                    Array.Copy(qkv, n * w3 + d, k, n * kvs, kvs);
                    Array.Copy(qkv, n * w3 + d + kvs, v, n * kvs, kvs);
                }
                lc.Qh = new double[N * d]; lc.Qnr = new double[N * H];
                lc.Qrot = Prim.RmsNorm(q, N * H, dk, P[p + "qn"], eps, lc.Qh, lc.Qnr);
                lc.Kh = new double[N * kvs]; lc.Knr = new double[N * KV];
                lc.Krot = Prim.RmsNorm(k, N * KV, dk, P[p + "kn"], eps, lc.Kh, lc.Knr);
                Prim.Rope(lc.Qrot, N, T, H, dk, cos, sin, false);
                Prim.Rope(lc.Krot, N, T, KV, dk, cos, sin, false);
                lc.V = v;
                lc.A = new double[B * H * T * T];
                lc.O = Prim.AttnCore(lc.Qrot, lc.Krot, v, B, T, H, KV, dk, lc.A);
                var att = Prim.XWt(lc.O, N, d, W, w3, d);
                for (int i = 0; i < h.Length; i++) h[i] += att[i];
                if (cfg.Kgd)
                {
                    double alpha, c;
                    Kgd(P, l, out alpha, out c);
                    lc.Kc = new KgdCache();
                    h = Prim.Kgd(h, B, T, d, alpha, c, eps, lc.Kc);
                }
                lc.X2h = new double[N * d]; lc.R2 = new double[N];
                lc.N2 = Prim.RmsNorm(h, N, d, P[p + "n2"], eps, lc.X2h, lc.R2);
                var u = Prim.XWt(lc.N2, N, d, P[p + "up"], 0, cfg.Dff);
                lc.Rl = new double[u.Length];
                lc.Act = new double[u.Length];
                for (int i = 0; i < u.Length; i++)
                {
                    double r = double.IsNaN(u[i]) ? u[i] : (u[i] > 0 ? u[i] : 0.0);
                    lc.Rl[i] = r;
                    lc.Act[i] = r * r;
                }
                var f = Prim.XWt(lc.Act, N, cfg.Dff, P[p + "down"], 0, d);
                for (int i = 0; i < h.Length; i++) h[i] += f[i];
                if (cache == null) { lc = null; }
                lcs[l] = lc;
            }
            var fh = new double[N * d];
            var fr = new double[N];
            var hf = Prim.RmsNorm(h, N, d, P["fn"], eps, fh, fr);
            var logits = Prim.XWt(hf, N, d, emb, 0, V);
            loss = double.NaN;
            double[] probs = null;
            if (targets != null)
            {
                probs = new double[N * V];
                double tot = 0;
                for (int n = 0; n < N; n++)
                {
                    int o = n * V;
                    double m = double.NegativeInfinity;
                    bool nan = false;
                    for (int j = 0; j < V; j++) { double x = logits[o + j]; if (double.IsNaN(x)) nan = true; else if (x > m) m = x; }
                    if (nan) m = double.NaN;
                    double Z = 0;
                    for (int j = 0; j < V; j++) { probs[o + j] = Math.Exp(logits[o + j] - m); Z += probs[o + j]; }
                    for (int j = 0; j < V; j++) probs[o + j] /= Z;
                    tot += logits[o + targets[n]] - m - Math.Log(Z);
                }
                loss = -tot / N;
            }
            if (cache != null)
            {
                cache.B = B; cache.T = T; cache.Tokens = tokens; cache.Targets = targets; cache.Layers = lcs; cache.F32 = f32;
                cache.Hf = hf; cache.Fh = fh; cache.Fr = fr; cache.Probs = probs; cache.Cos = cos; cache.Sin = sin; cache.Sd = sd;
            }
            return logits;
        }

        static void AddTo(float[] g, double[] d) { for (int i = 0; i < g.Length; i++) g[i] = (float)(g[i] + d[i]); }

        /// <summary>backward(P, cfg, cache): gradients of the mean next-token loss, as float32 tensors named like P.</summary>
        public static Params Backward(Params P, Cfg cfg, Cache cc)
        {
            int B = cc.B, T = cc.T, N = B * T, d = cfg.D, V = cfg.Vocab, H = cfg.Heads, KV = cfg.Kv, dk = cfg.Dk, kvs = cfg.KvSize, w3 = d + 2 * kvs;
            var G = P.ZerosLike();
            var dlog = new double[N * V];
            for (int n = 0; n < N; n++)
            {
                for (int j = 0; j < V; j++) dlog[n * V + j] = cc.Probs[n * V + j];
                dlog[n * V + cc.Targets[n]] -= 1.0;
                for (int j = 0; j < V; j++) dlog[n * V + j] /= N;
            }
            float[] emb = P["emb"];
            Prim.AccDtX(dlog, N, V, cc.Hf, d, G["emb"], 0);
            var dhf = Prim.DyW(dlog, N, V, emb, 0, d);
            var dfn = new double[d];
            var dh = Prim.RmsNormB(dhf, N, d, cc.Fh, cc.Fr, P["fn"], dfn);
            AddTo(G["fn"], dfn);
            int g = H / KV;
            double scale = 1.0 / Math.Sqrt(dk);
            for (int l = cfg.Layers - 1; l >= 0; l--)
            {
                string p = Lp(l);
                var lc = cc.Layers[l];
                // feed-forward
                Prim.AccDtX(dh, N, d, lc.Act, cfg.Dff, G[p + "down"], 0);
                var da = Prim.DyW(dh, N, d, P[p + "down"], 0, cfg.Dff);
                for (int i = 0; i < da.Length; i++) da[i] = da[i] * 2.0 * lc.Rl[i];
                Prim.AccDtX(da, N, cfg.Dff, lc.N2, d, G[p + "up"], 0);
                var dn2 = Prim.DyW(da, N, cfg.Dff, P[p + "up"], 0, d);
                var dw2 = new double[d];
                var dx2 = Prim.RmsNormB(dn2, N, d, lc.X2h, lc.R2, P[p + "n2"], dw2);
                AddTo(G[p + "n2"], dw2);
                for (int i = 0; i < dh.Length; i++) dh[i] += dx2[i];
                // KGD-IMQ step
                if (cfg.Kgd)
                {
                    double dalpha, dc;
                    dh = Prim.KgdB(dh, lc.Kc, out dalpha, out dc);
                    double a = P[p + "ka"][0], b = P[p + "kb"][0];
                    double sg = 1.0 / (1.0 + Math.Exp(-a));
                    G[p + "ka"][0] = (float)(G[p + "ka"][0] + dalpha * 0.5 * sg * (1.0 - sg));
                    G[p + "kb"][0] = (float)(G[p + "kb"][0] + dc * (1.0 / (1.0 + Math.Exp(-b))));
                }
                // attention
                float[] W = P[p + "qkvo"];
                Prim.AccDtX(dh, N, d, lc.O, d, G[p + "qkvo"], w3);
                var dO = Prim.DyW(dh, N, d, W, w3, d);
                var dQ = new double[N * d];
                var dK = new double[N * kvs];
                var dV = new double[N * kvs];
                Prim.For(B * KV, (long)B * H * T * T * dk, bk =>
                {
                    int b = bk / KV, kvh = bk % KV;
                    var dA = new double[T];
                    for (int hh = kvh * g; hh < (kvh + 1) * g; hh++)
                    {
                        for (int t = 0; t < T; t++)
                        {
                            int oo = (b * T + t) * d + hh * dk;
                            int ao = ((b * H + hh) * T + t) * T;
                            double rowdot = 0;
                            for (int s = 0; s <= t; s++)
                            {
                                int vo = ((b * T + s) * KV + kvh) * dk;
                                double acc = 0;
                                for (int j = 0; j < dk; j++) acc += dO[oo + j] * lc.V[vo + j];
                                dA[s] = acc;
                                double a = lc.A[ao + s];
                                rowdot += acc * a;
                                for (int j = 0; j < dk; j++) dV[vo + j] += a * dO[oo + j];
                            }
                            int qo = ((b * T + t) * H + hh) * dk;
                            for (int s = 0; s <= t; s++)
                            {
                                double dS = lc.A[ao + s] * (dA[s] - rowdot) * scale;
                                if (dS == 0) continue;
                                int ko = ((b * T + s) * KV + kvh) * dk;
                                for (int j = 0; j < dk; j++) { dQ[qo + j] += dS * lc.Krot[ko + j]; dK[ko + j] += dS * lc.Qrot[qo + j]; }
                            }
                        }
                    }
                });
                Prim.Rope(dQ, N, T, H, dk, cc.Cos, cc.Sin, true);
                Prim.Rope(dK, N, T, KV, dk, cc.Cos, cc.Sin, true);
                var dqn = new double[dk];
                var dkn = new double[dk];
                var dq = Prim.RmsNormB(dQ, N * H, dk, lc.Qh, lc.Qnr, P[p + "qn"], dqn);
                var dkk = Prim.RmsNormB(dK, N * KV, dk, lc.Kh, lc.Knr, P[p + "kn"], dkn);
                AddTo(G[p + "qn"], dqn);
                AddTo(G[p + "kn"], dkn);
                var dqkv = new double[N * w3];
                for (int n = 0; n < N; n++)
                {
                    Array.Copy(dq, n * d, dqkv, n * w3, d);
                    Array.Copy(dkk, n * kvs, dqkv, n * w3 + d, kvs);
                    Array.Copy(dV, n * kvs, dqkv, n * w3 + d + kvs, kvs);
                }
                Prim.AccDtX(dqkv, N, w3, lc.N1, d, G[p + "qkvo"], 0);
                var dn1 = Prim.DyW(dqkv, N, w3, W, 0, d);
                var dw1 = new double[d];
                var dx1 = Prim.RmsNormB(dn1, N, d, lc.X1h, lc.R1, P[p + "n1"], dw1);
                AddTo(G[p + "n1"], dw1);
                for (int i = 0; i < dh.Length; i++) dh[i] += dx1[i];
            }
            float[] ge = G["emb"];
            for (int n = 0; n < N; n++)
            {
                long tk = cc.Tokens[n];
                for (int j = 0; j < d; j++) ge[tk * d + j] = (float)(ge[tk * d + j] + dh[n * d + j] * cc.Sd);
            }
            return G;
        }

        static readonly double[,] PolarCoeffs = {
            { 8.156554524902461, -22.48329292557795, 15.878769915207462 },
            { 4.042929935166739, -2.808917465908714, 0.5000178451051316 },
            { 3.8916678022926607, -2.772484153217685, 0.5060648178503393 },
            { 3.285753657755655, -2.3681294933425376, 0.46449024233003106 },
            { 2.3465413258596377, -1.7097828382687081, 0.42323551169305323 } };

        static double Dot(double[] a, int ao, double[] b, int bo, int n)
        {
            double s0 = 0, s1 = 0, s2 = 0, s3 = 0;
            int k = 0;
            for (; k + 3 < n; k += 4)
            {
                s0 += a[ao + k] * b[bo + k]; s1 += a[ao + k + 1] * b[bo + k + 1];
                s2 += a[ao + k + 2] * b[bo + k + 2]; s3 += a[ao + k + 3] * b[bo + k + 3];
            }
            for (; k < n; k++) s0 += a[ao + k] * b[bo + k];
            return (s0 + s1) + (s2 + s3);
        }

        /// <summary>polar_express(G) for a matrix of r rows and c columns (the source's Muon orthogonalization, 5 steps).</summary>
        public static double[] PolarExpress(double[] Gm, int r, int c)
        {
            bool tall = r > c;
            int m = tall ? c : r, n = tall ? r : c;
            var X = new double[m * n];
            if (tall) { for (int i = 0; i < r; i++) for (int j = 0; j < c; j++) X[j * n + i] = Gm[i * c + j]; }
            else Array.Copy(Gm, X, X.Length);
            double ss = 0;
            for (int i = 0; i < X.Length; i++) ss += X[i] * X[i];
            double div = Math.Sqrt(ss) * 1.01 + 1e-7;
            for (int i = 0; i < X.Length; i++) X[i] /= div;
            var A = new double[m * m];
            var AA = new double[m * m];
            for (int it = 0; it < 5; it++)
            {
                double ca = PolarCoeffs[it, 0], cb = PolarCoeffs[it, 1], cc = PolarCoeffs[it, 2];
                var Xc = X;
                Prim.For(m, (long)m * m * n, i => { for (int j = i; j < m; j++) A[i * m + j] = Dot(Xc, i * n, Xc, j * n, n); });
                for (int i = 0; i < m; i++) for (int j = 0; j < i; j++) A[i * m + j] = A[j * m + i];
                Prim.For(m, (long)m * m * m, i => { for (int j = i; j < m; j++) AA[i * m + j] = Dot(A, i * m, A, j * m, m); });
                for (int i = 0; i < m; i++) for (int j = 0; j < i; j++) AA[i * m + j] = AA[j * m + i];
                var X2 = new double[m * n];
                Prim.For(m, (long)m * m * n, i =>
                {
                    int o = i * n;
                    for (int k = 0; k < n; k++) X2[o + k] = ca * Xc[o + k];
                    for (int j = 0; j < m; j++)
                    {
                        double bij = cb * A[i * m + j] + cc * AA[i * m + j];
                        if (bij == 0) continue;
                        int xo = j * n;
                        for (int k = 0; k < n; k++) X2[o + k] += bij * Xc[xo + k];
                    }
                });
                X = X2;
            }
            if (!tall) return X;
            var Y = new double[r * c];
            for (int i = 0; i < r; i++) for (int j = 0; j < c; j++) Y[i * c + j] = X[j * n + i];
            return Y;
        }
    }

    /// <summary>The source's optimizer recipe (kgd_model.Trainer): Muon (polar express) on block matrices, AdamW on the rest.</summary>
    public sealed class Trainer
    {
        readonly Params P;
        readonly double muonLr = 0.024, adamLr = 0.006, wd = 0.2, mom = 0.95, clip = 1.0;
        readonly int warmup = 1;
        public readonly List<string> Muon = new List<string>(), AdamW = new List<string>();
        readonly Dictionary<string, float[]> buf = new Dictionary<string, float[]>(), m1 = new Dictionary<string, float[]>(), m2 = new Dictionary<string, float[]>();
        public int StepN;
        public double MaxChange;

        public Trainer(Params p)
        {
            P = p;
            foreach (string k in p.Names)
            {
                if (Model.IsMuon(k)) { Muon.Add(k); buf[k] = new float[p[k].Length]; }
                else { AdamW.Add(k); m1[k] = new float[p[k].Length]; m2[k] = new float[p[k].Length]; }
            }
        }

        public double Factor() { return StepN < warmup ? (double)StepN / warmup : 1.0; }

        public double Step(Params G)
        {
            double total = 0;
            foreach (string k in G.Names) { float[] g = G[k]; double s = 0; for (int i = 0; i < g.Length; i++) s += (double)g[i] * g[i]; total += s; }
            total = Math.Sqrt(total);
            double scale = total > clip ? clip / (total + 1e-6) : 1.0;
            double f = Factor();
            MaxChange = 0;
            foreach (string k in Muon)
            {
                float[] g = G[k], b = buf[k], w = P[k];
                int r = P.Shape[k][0], c = P.Shape[k][1];
                var gn = new double[g.Length];
                for (int i = 0; i < g.Length; i++)
                {
                    float gi = (float)(g[i] * scale);
                    b[i] = (float)(mom * b[i] + (1 - mom) * gi);
                    gn[i] = (float)((1 - mom) * gi + mom * b[i]);
                }
                var X = Model.PolarExpress(gn, r, c);
                double lr = muonLr * f * Math.Sqrt(Math.Max(1.0, (double)r / c));
                for (int i = 0; i < w.Length; i++)
                {
                    float old = w[i];
                    w[i] = (float)(w[i] - lr * (float)X[i]);
                    Track(old, w[i]);
                }
            }
            int t = StepN + 1;
            foreach (string k in AdamW)
            {
                float[] g = G[k], w = P[k], a = m1[k], v = m2[k];
                string key = Model.Last(k);
                double wdk = (key == "ka" || key == "kb") ? 0.0 : wd;
                double lr = adamLr * f;
                double c1 = 1 - Math.Pow(0.9, t), c2 = 1 - Math.Pow(0.999, t);
                for (int i = 0; i < w.Length; i++)
                {
                    float old = w[i];
                    float gi = (float)(g[i] * scale);
                    w[i] = (float)(w[i] * (1 - lr * wdk));
                    a[i] = (float)(0.9 * a[i] + 0.1 * gi);
                    v[i] = (float)(0.999 * v[i] + 0.001 * gi * gi);
                    double mh = a[i] / c1, vh = v[i] / c2;
                    w[i] = (float)(w[i] - lr * mh / (Math.Sqrt(vh) + 1e-8));
                    Track(old, w[i]);
                }
            }
            StepN++;
            return total;
        }

        void Track(float old, float now)
        {
            double ch = Math.Abs((double)now - old);
            if (double.IsNaN(ch)) MaxChange = double.NaN;
            else if (!double.IsNaN(MaxChange) && ch > MaxChange) MaxChange = ch;
        }
    }

    // ======== 06_weights.cs ========
    /// <summary>
    /// A factored LittleBit matrix (lb_load.Factored): W (r x c) = D_r (U1 V1^T + U2 V2^T) D_c + sum_p a_p u_p v_p^T,
    /// with the sign vectors kept packed (32 per word). A view covers rows Row0 .. Row0 + Rows - 1.
    /// </summary>
    public sealed class Factored
    {
        public int R, C, Row0, Rows;
        public int[] U1, U2, V1, V2;
        public float[] Sr, Sc;
        public float[] A;
        public int[][] Du, Dv;

        public bool AnyA
        {
            get { if (A == null) return false; foreach (float a in A) if (a != 0) return true; return false; }
        }

        public int RankBound { get { int n = 2; if (A != null) foreach (float a in A) if (a != 0) n++; return n; } }

        public Factored View(int a, int b)
        {
            var f = (Factored)MemberwiseClone();
            f.Row0 = Row0 + a;
            f.Rows = b - a;
            return f;
        }

        static double Sg(int[] w, int i) { return ((w[i >> 5] >> (i & 31)) & 1) != 0 ? 1.0 : -1.0; }

        /// <summary>x [N, C] -> [N, Rows]</summary>
        public double[] Apply(double[] x, int N)
        {
            var y = new double[N * Rows];
            bool dict = AnyA;
            int P = dict ? A.Length : 0;
            Prim.For(N, (long)N * (R + C) * (2 + P), n =>
            {
                int xo = n * C;
                double z1 = 0, z2 = 0;
                var t = new double[P];
                for (int j = 0; j < C; j++)
                {
                    double xs = (double)(float)(x[xo + j] * Sc[j]);
                    z1 += Sg(V1, j) * xs;
                    z2 += Sg(V2, j) * xs;
                    if (dict) for (int p = 0; p < P; p++) t[p] += Sg(Dv[p], j) * x[xo + j];
                }
                int yo = n * Rows;
                for (int i = 0; i < Rows; i++)
                {
                    int ri = Row0 + i;
                    double v = (z1 * Sg(U1, ri) + z2 * Sg(U2, ri)) * Sr[ri];
                    if (dict) for (int p = 0; p < P; p++) v += t[p] * A[p] * Sg(Du[p], ri);
                    y[yo + i] = v;
                }
            });
            return y;
        }

        /// <summary>row idx of W (a full row index): [C]</summary>
        public double[] RowVector(int idx)
        {
            var y = new double[C];
            double a1 = Sg(U1, idx) * Sr[idx], a2 = Sg(U2, idx) * Sr[idx];
            bool dict = AnyA;
            for (int j = 0; j < C; j++)
            {
                double v = a1 * (Sg(V1, j) * Sc[j]) + a2 * (Sg(V2, j) * Sc[j]);
                if (dict) for (int p = 0; p < A.Length; p++) v += (Sg(Du[p], idx) * A[p]) * Sg(Dv[p], j);
                y[j] = v;
            }
            return y;
        }
    }

    /// <summary>What a host kernel needs from a loaded weight set.</summary>
    public interface IWeights
    {
        Cfg Config { get; }
        double[] Lin(string key, double[] x, int N, int a, int b);
        float[] Vec(string key);
        void Kgd(int l, out double alpha, out double c);
        double[] Embed(long[] tokens);
        double[] Logits(double[] h, int N);
    }

    public sealed class DenseWeights : IWeights
    {
        public readonly Params P;
        readonly Cfg cfg;
        public DenseWeights(Params p, Cfg c) { P = p; cfg = c; }
        public Cfg Config { get { return cfg; } }

        public double[] Lin(string key, double[] x, int N, int a, int b)
        {
            int cols = P.Shape[key][1];
            return Prim.XWt(x, N, cols, P[key], a, b - a);
        }

        public float[] Vec(string key) { return P[key]; }
        public void Kgd(int l, out double alpha, out double c) { Model.Kgd(P, l, out alpha, out c); }

        public double[] Embed(long[] tokens)
        {
            int d = cfg.D;
            var o = new double[tokens.Length * d];
            float[] e = P["emb"];
            for (int t = 0; t < tokens.Length; t++) for (int j = 0; j < d; j++) o[t * d + j] = e[tokens[t] * d + j];
            return o;
        }

        public double[] Logits(double[] h, int N) { return Prim.XWt(h, N, cfg.D, P["emb"], 0, cfg.Vocab); }
    }

    public sealed class FactoredWeights : IWeights
    {
        public readonly Dictionary<string, Factored> W = new Dictionary<string, Factored>(StringComparer.Ordinal);
        public readonly Dictionary<string, float[]> V = new Dictionary<string, float[]>(StringComparer.Ordinal);
        public readonly Dictionary<int, double[]> KgdVals = new Dictionary<int, double[]>();
        public readonly List<Factored> Emb = new List<Factored>();
        public Cfg Cfg;
        public Cfg Config { get { return Cfg; } }

        public double[] Lin(string key, double[] x, int N, int a, int b) { return W[key].View(a, b).Apply(x, N); }

        public float[] Vec(string key)
        {
            float[] v;
            if (!V.TryGetValue(key, out v)) throw new EngineError("vector " + key + " missing");
            return v;
        }

        public void Kgd(int l, out double alpha, out double c) { var v = KgdVals[l]; alpha = v[0]; c = v[1]; }

        public double[] Embed(long[] tokens)
        {
            int d = Cfg.D, rows = Cfg.EmbClusterRows;
            var o = new double[tokens.Length * d];
            for (int t = 0; t < tokens.Length; t++)
            {
                double[] r = Emb[(int)(tokens[t] / rows)].RowVector((int)(tokens[t] % rows));
                for (int j = 0; j < d; j++) o[t * d + j] = (float)r[j];
            }
            return o;
        }

        public double[] Logits(double[] h, int N)
        {
            int Vv = Cfg.Vocab, rows = Cfg.EmbClusterRows;
            var o = new double[N * Vv];
            for (int c = 0; c < Emb.Count; c++)
            {
                var y = Emb[c].Apply(h, N);
                for (int n = 0; n < N; n++) Array.Copy(y, n * rows, o, n * Vv + c * rows, rows);
            }
            return o;
        }
    }

    /// <summary>lb_load.py: weight sets for computation, every shard's SHA-512 checked against the manifest first.</summary>
    public static class Loader
    {
        public static IEnumerable<KeyValuePair<JObj, ShardData>> Shards(string manifestPath, string expectedSet)
        {
            var m = SetFiles.ReadManifest(manifestPath);
            string d = Path.GetDirectoryName(Path.GetFullPath(manifestPath));
            if (U.Sha512Text(SetFiles.SetTable(m.Arr("shards"))) != m.Str("set_sha512")) throw new EngineError("manifest table does not match its set SHA-512");
            if (expectedSet != null && expectedSet != m.Str("set_sha512")) throw new EngineError("the weight set is not the one the program pins");
            foreach (object o in m.Arr("shards"))
            {
                var s = (JObj)o;
                var sd = ShardData.Read(Path.Combine(d, s.Str("file")), true, true);
                if (sd.FileSha512 != s.Str("sha512")) throw new EngineError(s.Str("file") + ": SHA-512 differs from the manifest");
                yield return new KeyValuePair<JObj, ShardData>(m, sd);
            }
        }

        static float[] Tier2(ShardData s, string prefix, int n, int g)
        {
            var signs = s.F(prefix + "_S");
            var blocks = Words.UnpackU16(s.F(prefix + "_B"), n / g, (int)s.S(prefix + "_B_SHIFT"));
            var o = new float[n];
            for (int i = 0; i < n; i++) o[i] = (Words.SignBit(signs, i) ? 1f : -1f) * blocks[i / g];
            return o;
        }

        static float[] FromQ16(int[] w) { var o = new float[w.Length]; for (int i = 0; i < w.Length; i++) o[i] = Words.FromQ16(w[i]); return o; }

        public static DenseWeights Dense(string manifestPath, string expectedSet, out string tier)
        {
            var P = new Params();
            Cfg cfg = null;
            tier = null;
            Dictionary<string, int[]> shapes = null;
            foreach (var kv in Shards(manifestPath, expectedSet))
            {
                var m = kv.Key; var s = kv.Value;
                if (cfg == null)
                {
                    cfg = Cfg.FromJson(m.Obj("config"));
                    tier = m.Str("tier");
                    shapes = new Dictionary<string, int[]>(StringComparer.Ordinal);
                    foreach (var x in Model.Shapes(cfg)) shapes[x.Key] = x.Value;
                }
                bool exact = tier == "EXACT-BF16";
                int g = exact ? 0 : int.Parse(s.Head["LB_G_BLOCK"], U.Inv);
                if (s.Head["LB_SHARD"] == "EMB")
                {
                    int ne = (int)Model.Size(shapes["emb"]);
                    P.Add("emb", shapes["emb"], exact ? Words.UnpackBf16(s.F("LB_EMB_W"), ne) : Tier2(s, "LB_EMB", ne, g));
                    P.Add("fn", shapes["fn"], exact ? Words.UnpackBf16(s.F("LB_FN_W"), cfg.D) : FromQ16(s.F("LB_FN")));
                    continue;
                }
                int l = int.Parse(s.Head["LB_SHARD"].Substring(1), U.Inv);
                string p = Model.Lp(l), ll = "LB_L" + l.ToString("00", U.Inv);
                foreach (var kt in new[] { new[] { "qkvo", "QKVO" }, new[] { "up", "UP" }, new[] { "down", "DN" } })
                {
                    int[] sh = shapes[p + kt[0]];
                    int n = (int)Model.Size(sh);
                    P.Add(p + kt[0], sh, exact ? Words.UnpackBf16(s.F(ll + "_" + kt[1] + "_W"), n) : Tier2(s, ll + "_" + kt[1], n, g));
                }
                foreach (string key in new[] { "n1", "n2", "qn", "kn" })
                {
                    int n = shapes[p + key][0];
                    P.Add(p + key, shapes[p + key], exact ? Words.UnpackBf16(s.F(ll + "_" + key.ToUpperInvariant() + "_W"), n) : FromQ16(s.F(ll + "_" + key.ToUpperInvariant())));
                }
                float ka, kb;
                if (exact)
                {
                    var ab = Words.UnpackBf16(s.F(ll + "_KGD_W"), 2);
                    ka = ab[0]; kb = ab[1];
                }
                else
                {
                    double alpha = s.S(ll + "_KGD_ALPHA") / 65536.0, c = s.S(ll + "_KGD_C") / 65536.0;
                    ka = (float)Math.Log(2 * alpha / (1 - 2 * alpha));
                    kb = (float)Math.Log(FdLibm.Expm1(c));
                }
                P.Add(p + "ka", new int[0], new[] { ka });
                P.Add(p + "kb", new int[0], new[] { kb });
            }
            if (cfg == null) throw new EngineError("empty weight set");
            foreach (var x in Model.Shapes(cfg)) if (!P.Has(x.Key)) throw new EngineError("tensors missing from the set: " + x.Key);
            var ordered = new Params();
            foreach (var x in Model.Shapes(cfg)) ordered.Add(x.Key, x.Value, P[x.Key]);
            for (int l = 0; l < cfg.Layers; l++)
            {
                double alpha, c;
                Model.Kgd(ordered, l, out alpha, out c);
                if (!(alpha >= 0.0 && alpha <= 0.5) || !(c > 0))
                    throw new EngineError("block " + l.ToString(U.Inv) + ": inadmissible KGD-IMQ step alpha=" + U.PyRepr(alpha) + " c=" + U.PyRepr(c));
            }
            return new DenseWeights(ordered, cfg);
        }

        static Factored MakeFactored(ShardData s, string prefix, int r, int c, string tier)
        {
            var f = new Factored { R = r, C = c, Row0 = 0, Rows = r };
            f.U1 = s.F(prefix + "_U1"); f.V1 = s.F(prefix + "_V1"); f.U2 = s.F(prefix + "_U2"); f.V2 = s.F(prefix + "_V2");
            f.Sr = Words.UnpackU16(s.F(prefix + "_SR"), r, (int)s.S(prefix + "_SR_SHIFT"));
            f.Sc = Words.UnpackU16(s.F(prefix + "_SC"), c, (int)s.S(prefix + "_SC_SHIFT"));
            if (tier == "TIER-0") return f;
            var ps = new SortedSet<string>(StringComparer.Ordinal);
            foreach (string k in s.FamOrder)
                if (k.StartsWith(prefix + "_D", StringComparison.Ordinal) && k.Length >= prefix.Length + 4) ps.Add(k.Substring(prefix.Length + 2, 2));
            var plist = ps.ToList();
            f.Du = new int[plist.Count][]; f.Dv = new int[plist.Count][]; f.A = new float[plist.Count];
            for (int i = 0; i < plist.Count; i++)
            {
                f.Du[i] = s.F(prefix + "_D" + plist[i] + "U");
                f.Dv[i] = s.F(prefix + "_D" + plist[i] + "V");
                f.A[i] = (float)(s.S(prefix + "_A" + plist[i]) / 65536.0);
            }
            return f;
        }

        public static FactoredWeights FactoredSet(string manifestPath, string tier, string expectedSet)
        {
            var w = new FactoredWeights();
            Cfg cfg = null;
            var emb = new SortedDictionary<string, Factored>(StringComparer.Ordinal);
            foreach (var kv in Shards(manifestPath, expectedSet))
            {
                var m = kv.Key; var s = kv.Value;
                if (cfg == null) cfg = Cfg.FromJson(m.Obj("config"));
                int d = cfg.D, kvs = cfg.KvSize;
                string shard = s.Head["LB_SHARD"];
                if (shard.StartsWith("EMB", StringComparison.Ordinal))
                {
                    foreach (string k in s.FamOrder)
                        if (k.StartsWith("LB_E", StringComparison.Ordinal) && k.Length >= 6 && char.IsDigit(k[4]) && char.IsDigit(k[5]))
                        {
                            string cc = k.Substring(4, 2);
                            if (!emb.ContainsKey(cc)) emb[cc] = MakeFactored(s, "LB_E" + cc, cfg.EmbClusterRows, d, tier);
                        }
                    if (s.Fam.ContainsKey("LB_FN")) w.V["fn"] = FromQ16(s.F("LB_FN"));
                    continue;
                }
                int l = int.Parse(shard.Substring(1, 2), U.Inv);
                string p = Model.Lp(l), ll = "LB_L" + l.ToString("00", U.Inv);
                var mats = new[] {
                    new object[] { "qkvo", "QKVO", d + 2 * kvs + d, d }, new object[] { "up", "UP", cfg.Dff, d }, new object[] { "down", "DN", d, cfg.Dff } };
                foreach (var mt in mats)
                    if (s.Fam.ContainsKey(ll + "_" + (string)mt[1] + "_U1"))
                        w.W[p + (string)mt[0]] = MakeFactored(s, ll + "_" + (string)mt[1], (int)mt[2], (int)mt[3], tier);
                foreach (string key in new[] { "n1", "n2", "qn", "kn" })
                    if (s.Fam.ContainsKey(ll + "_" + key.ToUpperInvariant())) w.V[p + key] = FromQ16(s.F(ll + "_" + key.ToUpperInvariant()));
                if (s.Scal.ContainsKey(ll + "_KGD_ALPHA"))
                {
                    double alpha = s.S(ll + "_KGD_ALPHA") / 65536.0, c = s.S(ll + "_KGD_C") / 65536.0;
                    if (!(alpha >= 0.0 && alpha <= 0.5) || !(c > 0))
                        throw new EngineError("block " + l.ToString(U.Inv) + ": inadmissible KGD-IMQ step alpha=" + U.PyRepr(alpha) + " c=" + U.PyRepr(c));
                    w.KgdVals[l] = new[] { alpha, c };
                }
            }
            if (cfg == null) throw new EngineError("empty weight set");
            w.Cfg = cfg;
            foreach (var e in emb.Values) w.Emb.Add(e);
            var missing = new List<string>();
            if (!w.V.ContainsKey("fn")) missing.Add("fn");
            for (int l = 0; l < cfg.Layers; l++)
            {
                string p = Model.Lp(l);
                foreach (string k in new[] { "qkvo", "up", "down" }) if (!w.W.ContainsKey(p + k)) missing.Add(p + k);
                foreach (string k in new[] { "n1", "n2", "qn", "kn" }) if (!w.V.ContainsKey(p + k)) missing.Add(p + k);
                if (!w.KgdVals.ContainsKey(l)) missing.Add(p + "kgd");
            }
            if (missing.Count > 0 || w.Emb.Count * cfg.EmbClusterRows != cfg.Vocab)
                throw new EngineError("set is missing tensors: " + string.Join(", ", missing.Take(4)));
            return w;
        }

        public static IWeights Load(string manifestPath, string tier, string pin)
        {
            if (tier == "EXACT-BF16" || tier == "TIER-2") { string t; return Dense(manifestPath, pin, out t); }
            return FactoredSet(manifestPath, tier, pin);
        }
    }

    /// <summary>The host's per-row kernels (lcufx_kgd.py k_attn, k_kgd, k_ffn, k_head), on one sequence.</summary>
    public static class Kernels
    {
        public static double[] Embed(long[] tokens, IWeights w)
        {
            var e = w.Embed(tokens);
            double sd = Math.Sqrt(w.Config.D);
            for (int i = 0; i < e.Length; i++) e[i] = (float)(e[i] * sd);
            return e;
        }

        public static double[] Attn(double[] h, int T, IWeights w, int l)
        {
            var cfg = w.Config;
            int d = cfg.D, H = cfg.Heads, KV = cfg.Kv, dk = cfg.Dk, kvs = cfg.KvSize, w3 = d + 2 * kvs;
            string p = Model.Lp(l);
            var x = Prim.RmsNorm(h, T, d, w.Vec(p + "n1"), Prim.EpsF32, null, null);
            var qkv = w.Lin(p + "qkvo", x, T, 0, w3);
            var q = new double[T * d];
            var k = new double[T * kvs];
            var v = new double[T * kvs];
            for (int t = 0; t < T; t++)
            {
                Array.Copy(qkv, t * w3, q, t * d, d);
                Array.Copy(qkv, t * w3 + d, k, t * kvs, kvs);
                Array.Copy(qkv, t * w3 + d + kvs, v, t * kvs, kvs);
            }
            double[] cos, sin;
            Prim.RopeTables(T, dk, cfg.RopeBase, true, out cos, out sin);
            var qn = Prim.RmsNorm(q, T * H, dk, w.Vec(p + "qn"), Prim.EpsF32, null, null);
            var kn = Prim.RmsNorm(k, T * KV, dk, w.Vec(p + "kn"), Prim.EpsF32, null, null);
            Prim.Rope(qn, T, T, H, dk, cos, sin, false);
            Prim.Rope(kn, T, T, KV, dk, cos, sin, false);
            var O = Prim.AttnCore(qn, kn, v, 1, T, H, KV, dk, null);
            var o = w.Lin(p + "qkvo", O, T, w3, w3 + d);
            var y = new double[h.Length];
            for (int i = 0; i < y.Length; i++) y[i] = (float)(h[i] + o[i]);
            return y;
        }

        public static double[] KgdStep(double[] h, int T, IWeights w, int l)
        {
            double alpha, c;
            w.Kgd(l, out alpha, out c);
            if (!(alpha >= 0 && alpha <= 0.5 && c > 0)) throw new HostError("inadmissible KGD-IMQ step in block " + l.ToString(U.Inv));
            return Prim.ToF32(Prim.Kgd(h, 1, T, w.Config.D, alpha, c, Prim.EpsF32, null));
        }

        public static double[] Ffn(double[] h, int T, IWeights w, int l)
        {
            var cfg = w.Config;
            string p = Model.Lp(l);
            var x = Prim.RmsNorm(h, T, cfg.D, w.Vec(p + "n2"), Prim.EpsF32, null, null);
            var u = w.Lin(p + "up", x, T, 0, cfg.Dff);
            for (int i = 0; i < u.Length; i++) { double r = u[i] > 0 ? u[i] : (double.IsNaN(u[i]) ? u[i] : 0.0); u[i] = r * r; }
            var f = w.Lin(p + "down", u, T, 0, cfg.D);
            var y = new double[h.Length];
            for (int i = 0; i < y.Length; i++) y[i] = (float)(h[i] + f[i]);
            return y;
        }

        public static double[] Head(double[] h, int T, IWeights w)
        {
            var x = Prim.RmsNorm(h, T, w.Config.D, w.Vec("fn"), Prim.EpsF32, null, null);
            return Prim.ToF32(w.Logits(x, T));
        }

        public static double[] ForwardAll(long[] tokens, IWeights w)
        {
            int T = tokens.Length;
            var h = Embed(tokens, w);
            for (int l = 0; l < w.Config.Layers; l++) h = Ffn(KgdStep(Attn(h, T, w, l), T, w, l), T, w, l);
            return Head(h, T, w);
        }

        /// <summary>mean next-token cross-entropy of logits [T, V] (positions 0 .. T-2 score tokens 1 .. T-1).</summary>
        public static double Ce(double[] logits, int T, int V, long[] tokens)
        {
            double tot = 0;
            for (int t = 0; t < T - 1; t++)
            {
                int o = t * V;
                double m = double.NegativeInfinity;
                bool nan = false;
                for (int j = 0; j < V; j++) { if (double.IsNaN(logits[o + j])) nan = true; else if (logits[o + j] > m) m = logits[o + j]; }
                if (nan) m = double.NaN;
                double z = 0;
                for (int j = 0; j < V; j++) z += Math.Exp(logits[o + j] - m);
                tot += -(logits[o + tokens[t + 1]] - m - Math.Log(z));
            }
            return tot / (T - 1);
        }
    }

    // ======== 07_gen.cs ========
    /// <summary>The package's generators (export_model1.py, gen_model2.py, make_combined.py) and the data shards.</summary>
    public static class Gen
    {
        public const string PIN = "7eaa920315a7ef513f9b0ef3be99cdcfa6cf5d88";
        public const long ShardCap = 24000000, TotalCap = 1000000000;

        // ---------------- model 1: the seed-0 initialization, untrained ----------------
        static int U16Family(ShardWriter sh, string prefix, double[] x)
        {
            double mx = double.NegativeInfinity;
            foreach (double v in x) if (v > mx) mx = v;
            int k = 0;
            while (x.Length > 0 && mx / Math.Pow(2, k) >= 65535.5 / 65536) k++;
            sh.Scalar(prefix + "_SHIFT", k);
            var y = new double[x.Length];
            double div = Math.Pow(2, k);
            for (int i = 0; i < x.Length; i++) y[i] = x[i] / div;
            sh.Words(prefix, Words.PackU16(y));
            return k;
        }

        /// <summary>the note's Listing 1 in float64, every sum in index order (SPEC section 6).</summary>
        static void Rank1(double[] R, int rows, int cols, out double[] u, out double[] v, out double[] sr, out double[] sc)
        {
            var col = new double[cols];
            for (int i = 0; i < rows; i++) for (int j = 0; j < cols; j++) col[j] += Math.Abs(R[i * cols + j]);
            sc = new double[cols];
            for (int j = 0; j < cols; j++) sc[j] = Math.Sqrt(col[j] / rows + 1e-12);
            v = new double[cols];
            for (int j = 0; j < cols; j++) v[j] = 1.0;
            u = new double[rows];
            sr = new double[rows];
            var vs = new double[cols];
            var us = new double[rows];
            for (int it = 0; it < 12; it++)
            {
                for (int j = 0; j < cols; j++) vs[j] = v[j] * sc[j];
                double nvs = 0;
                for (int j = 0; j < cols; j++) nvs += vs[j] * vs[j];
                for (int i = 0; i < rows; i++)
                {
                    double s = 0;
                    int o = i * cols;
                    for (int j = 0; j < cols; j++) s += R[o + j] * vs[j];
                    u[i] = s >= 0 ? 1.0 : -1.0;
                    sr[i] = Math.Abs(s) / (nvs + 1e-12);
                    us[i] = u[i] * sr[i];
                }
                var dotc = new double[cols];
                for (int i = 0; i < rows; i++)
                {
                    int o = i * cols;
                    double ui = us[i];
                    for (int j = 0; j < cols; j++) dotc[j] += ui * R[o + j];
                }
                double nus = 0;
                for (int i = 0; i < rows; i++) nus += us[i] * us[i];
                for (int j = 0; j < cols; j++)
                {
                    v[j] = dotc[j] >= 0 ? 1.0 : -1.0;
                    sc[j] = Math.Abs(dotc[j]) / (nus + 1e-12);
                }
            }
        }

        static double RelErr(float[] W, Func<int, double> approx)
        {
            double num = 0, den = 0;
            for (int i = 0; i < W.Length; i++) { double d = (double)W[i] - approx(i); num += d * d; }
            for (int i = 0; i < W.Length; i++) { double w = W[i]; den += w * w; }
            return Math.Sqrt(num) / Math.Sqrt(den);
        }

        static JObj Tier2Matrix(ShardWriter sh, string name, float[] W, int r, int c)
        {
            int n = r * c;
            sh.Words(name + "_S", Words.PackSignsOf(W));
            int nb = n / 256;
            var blocks = new double[nb];
            for (int k = 0; k < nb; k++)
            {
                double s = 0;
                for (int j = 0; j < 256; j++) s += Math.Abs((double)W[256 * k + j]);
                blocks[k] = s / 256.0;
            }
            U16Family(sh, name + "_B", blocks);
            var W64 = new double[n];
            for (int i = 0; i < n; i++) W64[i] = W[i];
            double[] u1, v1, sr1, sc1, u2, v2, sr2, sc2;
            Rank1(W64, r, c, out u1, out v1, out sr1, out sc1);
            var R2 = new double[n];
            for (int i = 0; i < r; i++)
            {
                double a = sr1[i] * u1[i];
                for (int j = 0; j < c; j++) R2[i * c + j] = W64[i * c + j] - a * (v1[j] * sc1[j]);
            }
            Rank1(R2, r, c, out u2, out v2, out sr2, out sc2);
            var sr = new double[r];
            var sc = new double[c];
            for (int i = 0; i < r; i++) sr[i] = 0.5 * (sr1[i] + sr2[i]);
            for (int j = 0; j < c; j++) sc[j] = 0.5 * (sc1[j] + sc2[j]);
            sh.Words(name + "_U1", Words.PackSigns(u1));
            sh.Words(name + "_V1", Words.PackSigns(v1));
            sh.Words(name + "_U2", Words.PackSigns(u2));
            sh.Words(name + "_V2", Words.PackSigns(v2));
            U16Family(sh, name + "_SR", sr);
            U16Family(sh, name + "_SC", sc);
            var rep = new JObj();
            rep["shape"] = Json.List((long)r, (long)c);
            rep["tier2_rel_err"] = RelErr(W, i => (W[i] >= 0 ? 1.0 : -1.0) * blocks[i / 256]);
            rep["tier0_rank2_rel_err"] = RelErr(W, idx => { int i = idx / c, j = idx % c; return (sr[i] * (u1[i] * v1[j] + u2[i] * v2[j])) * sc[j]; });
            double ms = double.NegativeInfinity;
            foreach (double x in sr) ms = Math.Max(ms, x);
            foreach (double x in sc) ms = Math.Max(ms, x);
            foreach (double x in blocks) ms = Math.Max(ms, x);
            rep["max_scale"] = ms;
            return rep;
        }

        static long[] Q16All(float[] v) { var o = new long[v.Length]; for (int i = 0; i < v.Length; i++) o[i] = Words.Q16(v[i]); return o; }

        public static Cfg Model1Config() { return Cfg.Make(256, 256, 4, 4, 2, 1024, 128, 0.05, 1.0, true); }

        public static JObj Model1(string outDir, long seed)
        {
            var cfg = Model1Config();
            var P = Model.Init(cfg, seed);
            const string MODEL = "KGD-IMQ-5DLLM-M1";
            long epsQ16 = Words.Q16(Prim.EpsF32);
            string exD = Path.Combine(outDir, "exact"), t2D = Path.Combine(outDir, "tier2");
            Directory.CreateDirectory(exD);
            Directory.CreateDirectory(t2D);
            var exact = new List<JObj>();
            var tier2 = new List<JObj>();
            var errors = new JObj();
            var kgd = new List<object>();
            var keys = new[] { new[] { "qkvo", "QKVO" }, new[] { "up", "UP" }, new[] { "down", "DN" } };
            for (int l = 0; l < cfg.Layers; l++)
            {
                string p = Model.Lp(l), ll = "LB_L" + l.ToString("00", U.Inv), sn = "L" + l.ToString("00", U.Inv);
                var sh = new ShardWriter(MODEL, sn, "EXACT-BF16", epsQ16, PIN);
                foreach (var k in keys) sh.Words(ll + "_" + k[1] + "_W", Words.PackBf16(P[p + k[0]]));
                foreach (string k in new[] { "n1", "n2", "qn", "kn" }) sh.Words(ll + "_" + k.ToUpperInvariant() + "_W", Words.PackBf16(P[p + k]));
                sh.Words(ll + "_KGD_W", Words.PackBf16(new[] { P[p + "ka"][0], P[p + "kb"][0] }));
                double alpha, c;
                Prim.KgdValues(Words.Bf16Round(P[p + "ka"][0]), Words.Bf16Round(P[p + "kb"][0]), out alpha, out c);
                long qa = Words.Q16(alpha), qc = Words.Q16(c);
                var kj = new JObj();
                kj["block"] = (long)l; kj["alpha"] = alpha; kj["c"] = c; kj["alpha_q16"] = qa; kj["c_q16"] = qc;
                kgd.Add(kj);
                sh.Scalar(ll + "_KGD_ALPHA", qa);
                sh.Scalar(ll + "_KGD_C", qc);
                exact.Add(sh.Write(Path.Combine(exD, "shard_" + sn + ".cmd")));
                var t2 = new ShardWriter(MODEL, sn, "TIER-2", epsQ16, PIN).H("LB_G_BLOCK", "256");
                foreach (var k in keys)
                {
                    int[] s = P.Shape[p + k[0]];
                    errors[p + k[0]] = Tier2Matrix(t2, ll + "_" + k[1], P[p + k[0]], s[0], s[1]);
                }
                foreach (string k in new[] { "n1", "n2", "qn", "kn" }) t2.WordsOf(ll + "_" + k.ToUpperInvariant(), Q16All(P[p + k]));
                t2.Scalar(ll + "_KGD_ALPHA", qa);
                t2.Scalar(ll + "_KGD_C", qc);
                tier2.Add(t2.Write(Path.Combine(t2D, "shard_" + sn + ".cmd")));
            }
            var e = new ShardWriter(MODEL, "EMB", "EXACT-BF16", epsQ16, PIN);
            e.Words("LB_EMB_W", Words.PackBf16(P["emb"]));
            e.Words("LB_FN_W", Words.PackBf16(P["fn"]));
            exact.Add(e.Write(Path.Combine(exD, "shard_EMB.cmd")));
            var e2 = new ShardWriter(MODEL, "EMB", "TIER-2", epsQ16, PIN).H("LB_G_BLOCK", "256");
            errors["emb"] = Tier2Matrix(e2, "LB_EMB", P["emb"], cfg.Vocab, cfg.D);
            e2.WordsOf("LB_FN", Q16All(P["fn"]));
            tier2.Add(e2.Write(Path.Combine(t2D, "shard_EMB.cmd")));
            var meta = new JObj();
            meta["model"] = MODEL;
            meta["config"] = cfg.Json;
            meta["parameters"] = Model.NParams(cfg);
            meta["pinned_source_commit"] = PIN;
            meta["tensor_names"] = "the engine's Model.Shapes(config), the order of kgd_model.tensor_shapes";
            meta["trained"] = false;
            meta["seed"] = seed;
            var init = new JObj();
            init["matrices"] = "N(0, 0.02^2): numpy's PCG64 per tensor, seeded by SHA-512(\"seed:name\") (kgd_model.init_params)";
            init["norms"] = 1.0;
            init["kgd"] = new JObj().Set("alpha", 0.05).Set("c", 1.0);
            meta["init"] = init;
            var mx = new JObj();
            foreach (string k in meta.Keys) mx[k] = meta[k];
            mx["tier"] = "EXACT-BF16";
            mx["encoding"] = "every tensor as bfloat16 pairs (low half = even element), row-major; KGD_W holds the raw (a, b) of alpha = 0.5 sigmoid(a), c = softplus(b)";
            var m1 = SetFiles.WriteManifest(exD, mx, exact);
            var mt = new JObj();
            foreach (string k in meta.Keys) mt[k] = meta[k];
            mt["tier"] = "TIER-2";
            mt["g_block"] = 256L;
            mt["encoding"] = "sign bitplane (row-major, 32 per word) with mean-|W| scales per block of 256 elements (U0.16 with a power-of-two SHIFT); Dual-SVID rank-2 factors U1 V1 U2 V2 with shared SR/SC scales; norms and KGD alpha/c in Q16.16";
            mt["reconstruction"] = "W_ij = sign_ij * block_scale(ij); the Dual-SVID factors are carried as in the note and are not combined in this reconstruction";
            mt["arithmetic"] = "block scales and Dual-SVID in float64 with every sum in index order (SPEC section 6), so any implementation writes the same words";
            var m2 = SetFiles.WriteManifest(t2D, mt, tier2);
            var rep = new JObj();
            rep["model"] = MODEL;
            rep["trained"] = false;
            rep["exact"] = new JObj().Set("set_sha512", m1["set_sha512"]).Set("total_bytes", m1["total_bytes"]);
            rep["tier2"] = new JObj().Set("set_sha512", m2["set_sha512"]).Set("total_bytes", m2["total_bytes"]);
            rep["kgd"] = kgd;
            rep["matrix_errors"] = errors;
            Doc.WriteJson(Path.Combine(outDir, "export_report.cmd"), "export_report.json", rep);
            return rep;
        }

        // ---------------- model 2: the Tier-1 capacity build, untrained ----------------
        static readonly double S_INIT = 0.02 * Math.Sqrt(2 / Math.PI);
        static readonly double S_SCALE = Math.Sqrt(S_INIT);
        static readonly string[] DICT = { "03", "04", "05", "06", "07", "08", "09", "10" };
        public const int CLUSTERS = 16, CLUSTER_ROWS = 3072, VOCAB = 49152;

        static int[] SignWords(long seed, string name, int n)
        {
            var g = Pcg64.FromText(seed.ToString(U.Inv) + ":" + name);
            var w = new int[n / 32];
            for (int i = 0; i < w.Length; i++) w[i] = (int)g.Integer(-2147483648L, 2147483648L);
            return w;
        }

        static int[] FullU16(int n, double v)
        {
            var x = new double[n];
            for (int i = 0; i < n; i++) x[i] = v;
            return Words.PackU16(x);
        }

        static long FactorBlock(ShardWriter sh, long seed, string prefix, int r, int c)
        {
            sh.Words(prefix + "_U1", SignWords(seed, prefix + "_U1", r));
            sh.Words(prefix + "_V1", SignWords(seed, prefix + "_V1", c));
            sh.Words(prefix + "_U2", SignWords(seed, prefix + "_U2", r));
            sh.Words(prefix + "_V2", SignWords(seed, prefix + "_V2", c));
            sh.Scalar(prefix + "_SR_SHIFT", 0);
            sh.Words(prefix + "_SR", FullU16(r, S_SCALE));
            sh.Scalar(prefix + "_SC_SHIFT", 0);
            sh.Words(prefix + "_SC", FullU16(c, S_SCALE));
            foreach (string p in DICT)
            {
                sh.Words(prefix + "_D" + p + "U", SignWords(seed, prefix + "_D" + p + "U", r));
                sh.Words(prefix + "_D" + p + "V", SignWords(seed, prefix + "_D" + p + "V", c));
                sh.Scalar(prefix + "_A" + p, 0);
            }
            return (long)r * c;
        }

        public static JObj Model2Config(int d, int layers)
        {
            int H = d / 64;
            var j = new JObj();
            j["vocab"] = (long)VOCAB; j["d"] = (long)d; j["n_layers"] = (long)layers; j["n_heads"] = (long)H; j["n_kv"] = (long)(H / 2);
            j["d_k"] = 64L; j["d_ff"] = (long)(4 * d); j["seq_len"] = 2048L; j["rope_base"] = 10000.0; j["kgd"] = true;
            j["alpha_init"] = 0.05; j["c_init"] = 1.0; j["emb_clusters"] = (long)CLUSTERS; j["emb_cluster_rows"] = (long)CLUSTER_ROWS;
            return j;
        }

        static JObj Finish(ShardWriter sh, string path, long nominal)
        {
            var rec = sh.Write(path);
            rec["nominal_parameters"] = nominal;
            rec["bytes_bound_any_values"] = ShardData.Read(path, false, false).BoundAnyValues;
            return rec;
        }

        public static List<JObj> Model2Layer(string outDir, long seed, Cfg cfg, int l, bool split)
        {
            const string MODEL = "KGD-IMQ-5DLLM-M2";
            int d = cfg.D, kv = cfg.KvSize, dff = cfg.Dff;
            string ll = "LB_L" + l.ToString("00", U.Inv), sn = "L" + l.ToString("00", U.Inv);
            var shapes = new Dictionary<string, int[]> { { "QKVO", new[] { d + 2 * kv + d, d } }, { "UP", new[] { dff, d } }, { "DN", new[] { d, dff } } };
            var sizes = new Dictionary<string, int> { { "N1", d }, { "N2", d }, { "QN", 64 }, { "KN", 64 } };
            var parts = split
                ? new[] { new object[] { "_ATTN", new[] { "QKVO" }, new[] { "N1", "QN", "KN" }, true }, new object[] { "_FFN", new[] { "UP", "DN" }, new[] { "N2" }, false } }
                : new[] { new object[] { "", new[] { "QKVO", "UP", "DN" }, new[] { "N1", "N2", "QN", "KN" }, true } };
            var recs = new List<JObj>();
            foreach (var part in parts)
            {
                string suffix = (string)part[0];
                var sh = new ShardWriter(MODEL, sn + suffix, "TIER-1", 0, PIN).H("LB_TIER0_SUBSET", "U1,V1,U2,V2,SR,SC").H("LB_DICT_RANK", "8");
                long nominal = 0;
                foreach (string m in (string[])part[1]) nominal += FactorBlock(sh, seed, ll + "_" + m, shapes[m][0], shapes[m][1]);
                foreach (string key in (string[])part[2])
                {
                    var ones = new long[sizes[key]];
                    for (int i = 0; i < ones.Length; i++) ones[i] = Words.Q16(1.0);
                    sh.WordsOf(ll + "_" + key, ones);
                    nominal += sizes[key];
                }
                if ((bool)part[3])
                {
                    sh.Scalar(ll + "_KGD_ALPHA", Words.Q16(cfg.AlphaInit));
                    sh.Scalar(ll + "_KGD_C", Words.Q16(cfg.CInit));
                    nominal += 2;
                }
                recs.Add(Finish(sh, Path.Combine(outDir, "shard_" + sn + suffix + ".cmd"), nominal));
            }
            return recs;
        }

        public static JObj Model2(string outDir, int d, int layers, long seed, bool split)
        {
            const string MODEL = "KGD-IMQ-5DLLM-M2";
            Directory.CreateDirectory(outDir);
            var cj = Model2Config(d, layers);
            var cfg = Cfg.FromJson(cj);
            var shards = new List<JObj>();
            for (int part = 0; part < 2; part++)
            {
                int c0 = part * 8, c1 = c0 + 8;
                var sh = new ShardWriter(MODEL, "EMB" + part.ToString(U.Inv), "TIER-1", 0, PIN)
                    .H("LB_EMB_CLUSTERS", c0.ToString(U.Inv) + "-" + (c1 - 1).ToString(U.Inv)).H("LB_CLUSTER_ROWS", CLUSTER_ROWS.ToString(U.Inv));
                long nominal = 0;
                for (int c = c0; c < c1; c++) nominal += FactorBlock(sh, seed, "LB_E" + c.ToString("00", U.Inv), CLUSTER_ROWS, d);
                if (part == 1)
                {
                    var ones = new long[d];
                    for (int i = 0; i < d; i++) ones[i] = Words.Q16(1.0);
                    sh.WordsOf("LB_FN", ones);
                    nominal += d;
                }
                shards.Add(Finish(sh, Path.Combine(outDir, "shard_EMB" + part.ToString(U.Inv) + ".cmd"), nominal));
            }
            for (int l = 0; l < layers; l++) shards.AddRange(Model2Layer(outDir, seed, cfg, l, split));
            long nominalAll = 0, words = 0, bound = 0;
            foreach (var s in shards) { nominalAll += s.Long("nominal_parameters"); words += s.Long("payload_lines"); bound += s.Long("bytes_bound_any_values"); }
            long signWords = 0;
            foreach (var rc in new[] { new[] { 3L * d, d }, new[] { 4L * d, d }, new[] { (long)d, 4L * d } }) signWords += 10 * (rc[0] + rc[1]) / 32;
            signWords = signWords * layers + CLUSTERS * 10L * (CLUSTER_ROWS + d) / 32;
            var meta = new JObj();
            meta["model"] = MODEL;
            meta["tier"] = "TIER-1";
            meta["tier0_subset"] = "the U1, V1, U2, V2, SR and SC families of every matrix";
            meta["config"] = cj;
            meta["trained"] = false;
            meta["seed"] = seed;
            meta["pinned_source_commit"] = PIN;
            var init = new JObj();
            init["sign_factors"] = "Rademacher, PCG64 seeded by SHA-512(seed:variable family)";
            init["svid_scales"] = "row and column scales " + S_SCALE.ToString("F8", U.Inv) + " each (U0.16 " + U.RoundHalfEven(S_SCALE * 65536).ToString("0", U.Inv) +
                                  ", note eq. 18); their product " + S_INIT.ToString("F8", U.Inv) + " = E|W| for N(0, 0.02^2)";
            init["dictionary_weights"] = 0L;
            init["norms"] = 1.0;
            init["kgd"] = new JObj().Set("alpha", 0.05).Set("c", 1.0);
            meta["init"] = init;
            meta["nominal_parameters"] = nominalAll;
            meta["stored_words"] = words;
            meta["stored_bits"] = 32 * words;
            meta["random_sign_words"] = signWords;
            meta["rank_bound"] = new JObj().Set("tier0", 2L).Set("tier1", 10L).Set("effective_at_init", 2L);
            meta["caps"] = new JObj().Set("shard_bytes", ShardCap).Set("applies_to", "bytes_bound_any_values of every shard (the largest size any trained values can give)");
            meta["total_bytes_bound_any_values"] = bound;
            var m = SetFiles.WriteManifest(outDir, meta, shards);
            long mxb = 0, mxbound = 0;
            foreach (var s in shards) { mxb = Math.Max(mxb, s.Long("bytes")); mxbound = Math.Max(mxbound, s.Long("bytes_bound_any_values")); }
            var r = new JObj();
            foreach (string k in new[] { "nominal_parameters", "stored_words", "total_bytes", "total_bytes_bound_any_values", "set_sha512" }) r[k] = m[k];
            r["shards"] = (long)shards.Count;
            r["max_shard"] = mxb;
            r["max_shard_bound"] = mxbound;
            return r;
        }

        // ---------------- the combined manifest ----------------
        public static JObj Combined(string weightsDir)
        {
            var defs = new[] { new object[] { "model1-untrained/exact", 2951944L }, new object[] { "model1-untrained/tier2", 2951944L }, new object[] { "model2-tier1", null } };
            var sets = new List<object>();
            var table = new StringBuilder();
            long total = 0;
            foreach (var dfn in defs)
            {
                string folder = (string)dfn[0];
                var m = SetFiles.ReadManifest(Path.Combine(weightsDir, folder.Replace('/', Path.DirectorySeparatorChar), SetFiles.ManifestFile));
                var s = new JObj();
                s["folder"] = folder; s["model"] = m["model"]; s["tier"] = m["tier"]; s["set_sha512"] = m["set_sha512"];
                s["shards"] = (long)m.Arr("shards").Count; s["total_bytes"] = m["total_bytes"];
                s["nominal_parameters"] = dfn[1] ?? m["nominal_parameters"];
                s["trained"] = false;
                sets.Add(s);
                table.Append(folder).Append(' ').Append(m.Str("set_sha512")).Append('\n');
                if (folder != "model1-untrained/tier2") total += Json.ToLong(s["nominal_parameters"]);
            }
            var c = new JObj();
            c["format"] = "LB-CMD/1 combined manifest";
            c["sets"] = sets;
            c["combined_rule"] = "combined_sha512 = SHA-512 of the lines '<set folder> <set_sha512>\\n' in the listed order";
            c["combined_sha512"] = U.Sha512Text(table.ToString());
            c["caps"] = new JObj().Set("shard_bytes", ShardCap).Set("all_files_bytes", TotalCap)
                .Set("applies_to", "the files now, and the bound any values can reach (tools\\LB_CMD.cmd combined): training changes values, never the number of words");
            c["nominal_parameters_total"] = total;
            c["note"] = "model 1's two sets are two encodings of one untrained model (its seed-0 initialization), so its parameters are counted once; neither model is trained";
            Doc.WriteJson(Path.Combine(weightsDir, "COMBINED-MANIFEST.cmd"), "COMBINED-MANIFEST.json", c);
            return new JObj().Set("combined_sha512", c["combined_sha512"]).Set("nominal_parameters_total", total);
        }

        // ---------------- data: LB-CMD/1 BYTES shards ----------------
        public const int WordsPerDataShard = 500000;

        public static List<JObj> DataPack(string src, string outDir, string stem, string label)
        {
            byte[] raw = File.ReadAllBytes(src);
            string full = U.Sha512Hex(raw);
            int nw = (raw.Length + 3) / 4;
            var recs = new List<JObj>();
            for (int k = 0, w0 = 0; w0 < nw; k++, w0 += WordsPerDataShard)
            {
                int cnt = Math.Min(WordsPerDataShard, nw - w0);
                var w = new int[cnt];
                for (int i = 0; i < cnt; i++)
                {
                    int b = 4 * (w0 + i);
                    uint v = 0;
                    for (int q = 0; q < 4; q++) if (b + q < raw.Length) v |= (uint)raw[b + q] << (8 * q);
                    w[i] = unchecked((int)v);
                }
                long off = 4L * w0;
                long nbytes = Math.Min(raw.Length - off, 4L * cnt);
                var sh = new ShardWriter();
                sh.Comment = ShardWriter.DataComment;
                sh.H("LB_FORMAT", "LB-CMD/1").H("LB_MODEL", "KGD-IMQ-5DLLM-CORPUS").H("LB_SHARD", label + k.ToString("00", U.Inv)).H("LB_TIER", "BYTES")
                  .H("LB_DATA_FILE", Path.GetFileName(src)).H("LB_DATA_TOTAL_BYTES", raw.Length.ToString(U.Inv)).H("LB_DATA_SHA512", full)
                  .H("LB_DATA_OFFSET", off.ToString(U.Inv)).H("LB_DATA_BYTES", nbytes.ToString(U.Inv));
                sh.Words("LB_BYTES_W", w);
                recs.Add(sh.Write(Path.Combine(outDir, stem + "_" + k.ToString("00", U.Inv) + ".cmd")));
            }
            return recs;
        }

        /// <summary>The original bytes of a data file from its shards (any order); checks LB_DATA_SHA512.</summary>
        public static byte[] DataUnpack(IEnumerable<string> shardPaths)
        {
            byte[] outb = null;
            string full = null;
            long filled = 0;
            foreach (string p in shardPaths)
            {
                var s = ShardData.Read(p, true, true);
                if (s.Head["LB_TIER"] != "BYTES") throw new EngineError(Path.GetFileName(p) + ": not a BYTES shard");
                long total = long.Parse(s.Head["LB_DATA_TOTAL_BYTES"], U.Inv);
                if (outb == null) { outb = new byte[total]; full = s.Head["LB_DATA_SHA512"]; }
                long off = long.Parse(s.Head["LB_DATA_OFFSET"], U.Inv), nb = long.Parse(s.Head["LB_DATA_BYTES"], U.Inv);
                int[] w = s.F("LB_BYTES_W");
                for (long i = 0; i < nb; i++) outb[off + i] = (byte)((uint)w[i >> 2] >> (int)(8 * (i & 3)));
                filled += nb;
            }
            if (outb == null) throw new EngineError("no data shards");
            if (filled != outb.Length || U.Sha512Hex(outb) != full) throw new EngineError("data shards do not rebuild the file (SHA-512 differs)");
            return outb;
        }

        public static List<string> DataShards(string dataDir, string stem)
        {
            var l = Directory.GetFiles(dataDir, stem + "_*.cmd").ToList();
            l.Sort(string.CompareOrdinal);
            return l;
        }
    }

    // ======== 08_host.cs ========
    public class HostError : EngineError
    {
        public HostError(string message) : base(message) { }
    }

    /// <summary>A host type: i64, f64, text, unit, Tokens[T], Hidden[T,d], Logits[T,V], WeightSet[label], Port[label].</summary>
    public sealed class HType
    {
        public string Kind, Label;
        public long A, B;
        public bool Same(HType o) { return o != null && Kind == o.Kind && A == o.A && B == o.B && Label == o.Label; }
        public bool Is(string k) { return Kind == k && A == 0 && B == 0 && Label == null; }
    }

    public sealed class HRow
    {
        public string Id, Site, Profile, Op, InputsCell, Output, TypeText, Evidence;
        public List<string> Inputs = new List<string>(), Effects, Caps, After;
        public long Budget;
        public int Line;
        public HType T;
        public object Literal;
        public bool IsConst;
    }

    public sealed class HSite { public string Trust; public long Memory, Steps; }

    public sealed class Program1
    {
        public string Module;
        public List<string> SiteOrder = new List<string>();
        public Dictionary<string, HSite> Sites = new Dictionary<string, HSite>(StringComparer.Ordinal);
        public Dictionary<string, HashSet<string>> Grants = new Dictionary<string, HashSet<string>>(StringComparer.Ordinal);
        public List<string> GrantOrder = new List<string>();
        public List<HRow> Rows = new List<HRow>();
    }

    public sealed class WsSpec { public string Path, Pin, Tier, Label; public Cfg Config; public long Bytes, Rank; public List<string> Shards; public double Alpha; public long DataBytes; }

    public sealed class PortSpec { public Cfg Config; public long Seed, Params; }

    public sealed class Compiled
    {
        public Program1 Prog;
        public JObj Ir;
        public List<string> Order;
        public Dictionary<string, HRow> ById, Outputs;
        public Dictionary<string, WsSpec> Sets;
        public Dictionary<string, PortSpec> Ports;
        public string SemanticSha512, SourceSha512;
    }

    /// <summary>Values the evaluator holds.</summary>
    public sealed class Arr { public double[] V; public long[] Shape; public bool IsTokens; public long[] Tok; }

    public sealed class PortVal { public Cfg Config; public Params P; }

    /// <summary>The host of the LCUF-X/0.2 profile extension lkvexa.kgd_imq/0.2: the operations of 0.1 (the port of
    /// lcufx_kgd.py) and the reasoning layer RAILS-8S/1 (profile column lkvexa.rails8s).</summary>
    public static class Host
    {
        public const string LANGUAGE = "LCUF-X/0.2+lkvexa.kgd_imq/0.2";
        public const string VERSION = "0.3.0";
        static readonly string[] COLUMNS = { "id", "site", "profile", "op", "inputs", "output", "type", "effects", "caps", "after", "budget", "evidence" };
        static readonly Regex IDENT = new Regex(@"^[A-Za-z_][A-Za-z0-9_.-]*\z", RegexOptions.CultureInvariant);
        static readonly Regex SITE = new Regex(@"^site (\S+) trust=(\S+) memory=([1-9][0-9]{0,18}) steps=([1-9][0-9]{0,18})\z", RegexOptions.CultureInvariant);
        static readonly Regex GRANT = new Regex(@"^grant (\S+) caps=(\S+)\z", RegexOptions.CultureInvariant);
        static readonly Regex BUDGET = new Regex(@"^[1-9][0-9]{0,18}\z", RegexOptions.CultureInvariant);
        static readonly Dictionary<string, object[]> OPS = new Dictionary<string, object[]>(StringComparer.Ordinal) {
            { "const", new object[] { "lcuf.scalar", 0 } }, { "emit", new object[] { "lcuf.evidence", 1 } }, { "assert_eq", new object[] { "lcuf.test", 2 } },
            { "assert_close", new object[] { "lkvexa.test", 3 } }, { "assert_le", new object[] { "lkvexa.test", 2 } },
            { "lb_load", new object[] { "lkvexa.weights.cmd", 3 } }, { "tokens_utf8", new object[] { "lkvexa.bytes", 1 } },
            { "embed", new object[] { "lkvexa.llm", 2 } }, { "attn_block", new object[] { "lkvexa.llm", 3 } }, { "kgd_imq_step", new object[] { "lkvexa.kgd_imq", 3 } },
            { "ffn_block", new object[] { "lkvexa.llm", 3 } }, { "head", new object[] { "lkvexa.llm", 2 } }, { "next_token_ce", new object[] { "lkvexa.llm", 2 } },
            { "greedy_bytes", new object[] { "lkvexa.llm.decode", 3 } }, { "assert_json", new object[] { "lkvexa.test", 2 } },
            { "port_build", new object[] { "lkvexa.port", 2 } }, { "port_count", new object[] { "lkvexa.port", 2 } }, { "port_forward_report", new object[] { "lkvexa.port", 2 } },
            { "port_first_update", new object[] { "lkvexa.port", 2 } }, { "port_loop_probe", new object[] { "lkvexa.port", 3 } },
            { "port_step_account", new object[] { "lkvexa.port", 3 } },
            { "rails_bayes", new object[] { "lkvexa.rails8s", 1 } }, { "rails_admit", new object[] { "lkvexa.rails8s", 1 } },
            { "rails_meanfield", new object[] { "lkvexa.rails8s", 1 } }, { "rails_parity", new object[] { "lkvexa.rails8s", 4 } },
            { "rails_witness", new object[] { "lkvexa.rails8s", 2 } }, { "rails_codelen", new object[] { "lkvexa.rails8s", 2 } },
            { "bytes_unigram", new object[] { "lkvexa.rails8s", 3 } }, { "json_f64", new object[] { "lkvexa.rails8s", 2 } } };
        static readonly HashSet<string> RAILS_TEXT = new HashSet<string>(StringComparer.Ordinal) {
            "rails_bayes", "rails_admit", "rails_meanfield", "rails_parity", "rails_witness", "rails_codelen" };
        static readonly Dictionary<string, string> TIERS = new Dictionary<string, string>(StringComparer.Ordinal) {
            { "exact", "EXACT-BF16" }, { "tier2", "TIER-2" }, { "tier1", "TIER-1" }, { "tier0", "TIER-0" } };
        public const int PROBE_BATCH = 4, PROBE_LOADER = 40;

        static void Fail(string msg, int line) { throw new HostError((line > 0 ? "line " + line.ToString(U.Inv) + ": " : "") + msg); }
        static void Fail(string msg) { Fail(msg, 0); }

        public static string EngineSha512()
        {
            string src = Environment.GetEnvironmentVariable("KGD_SRC");
            return (src != null && File.Exists(src)) ? U.Sha512File(src) : "unknown";
        }

        // ---------------- parsing ----------------
        static HType Typ(string text, int line)
        {
            if (text == "i64" || text == "f64" || text == "text" || text == "unit") return new HType { Kind = text };
            Match m;
            if ((m = Regex.Match(text, @"^Tokens\[([1-9][0-9]{0,4})\]\z")).Success) return new HType { Kind = "Tokens", A = long.Parse(m.Groups[1].Value, U.Inv) };
            if ((m = Regex.Match(text, @"^Hidden\[([1-9][0-9]{0,4}),([1-9][0-9]{0,6})\]\z")).Success)
                return new HType { Kind = "Hidden", A = long.Parse(m.Groups[1].Value, U.Inv), B = long.Parse(m.Groups[2].Value, U.Inv) };
            if ((m = Regex.Match(text, @"^Logits\[([1-9][0-9]{0,4}),([1-9][0-9]{0,6})\]\z")).Success)
                return new HType { Kind = "Logits", A = long.Parse(m.Groups[1].Value, U.Inv), B = long.Parse(m.Groups[2].Value, U.Inv) };
            if ((m = Regex.Match(text, @"^WeightSet\[([A-Za-z_][A-Za-z0-9_]*)\]\z")).Success) return new HType { Kind = "WeightSet", Label = m.Groups[1].Value };
            if ((m = Regex.Match(text, @"^Port\[([A-Za-z_][A-Za-z0-9_]*)\]\z")).Success) return new HType { Kind = "Port", Label = m.Groups[1].Value };
            Fail("unsupported type " + text, line);
            return null;
        }

        static List<string> Names(string x, int line)
        {
            if (x == "-") return new List<string>();
            var parts = x.Split(',').ToList();
            foreach (string p in parts) if (!IDENT.IsMatch(p)) Fail("invalid identifier", line);
            return parts;
        }

        public static Program1 Parse(byte[] raw)
        {
            if (raw.Length > 1048576) Fail("source exceeds 1 MiB");
            string text;
            try
            {
                int skip = (raw.Length >= 3 && raw[0] == 0xEF && raw[1] == 0xBB && raw[2] == 0xBF) ? 3 : 0;
                text = U.Utf8Strict.GetString(raw, skip, raw.Length - skip);
            }
            catch (DecoderFallbackException) { throw new HostError("source is not UTF-8"); }
            var lines = new List<KeyValuePair<int, string>>();
            string[] split = text.Split('\n');
            for (int i = 0; i < split.Length; i++)
            {
                string s = split[i].Trim();
                if (s.Length > 0 && !s.StartsWith("#", StringComparison.Ordinal)) lines.Add(new KeyValuePair<int, string>(i + 1, s));
            }
            if (lines.Count == 0 || lines[0].Value != LANGUAGE) Fail("required header " + LANGUAGE);
            var p = new Program1();
            bool inRows = false, ended = false;
            for (int li = 1; li < lines.Count; li++)
            {
                int line = lines[li].Key;
                string s = lines[li].Value;
                if (ended) Fail("content after end", line);
                if (s == "end") { ended = true; continue; }
                if (p.Module == null && !s.StartsWith("module ", StringComparison.Ordinal)) Fail("module must be first", line);
                if (!inRows)
                {
                    if (s.StartsWith("module ", StringComparison.Ordinal)) p.Module = s.Split((char[])null, StringSplitOptions.RemoveEmptyEntries)[1];
                    else if (s.StartsWith("site ", StringComparison.Ordinal))
                    {
                        var m = SITE.Match(s);
                        long mem, st;
                        if (!m.Success || p.Sites.ContainsKey(m.Groups[1].Value) || !long.TryParse(m.Groups[3].Value, out mem) || !long.TryParse(m.Groups[4].Value, out st))
                            { Fail("site declaration", line); return null; }
                        p.Sites[m.Groups[1].Value] = new HSite { Trust = m.Groups[2].Value, Memory = mem, Steps = st };
                        p.SiteOrder.Add(m.Groups[1].Value);
                    }
                    else if (s.StartsWith("grant ", StringComparison.Ordinal))
                    {
                        var m = GRANT.Match(s);
                        if (!m.Success || p.Grants.ContainsKey(m.Groups[1].Value)) Fail("grant declaration", line);
                        p.Grants[m.Groups[1].Value] = new HashSet<string>(Names(m.Groups[2].Value, line), StringComparer.Ordinal);
                        p.GrantOrder.Add(m.Groups[1].Value);
                    }
                    else if (s.Split('|').Select(x => x.Trim()).SequenceEqual(COLUMNS)) inRows = true;
                    else Fail("unknown declaration or columns", line);
                }
                else
                {
                    var cells = s.Split('|').Select(x => x.Trim()).ToArray();
                    if (cells.Length != 12) Fail("twelve column cells required", line);
                    var r = new HRow { Id = cells[0], Site = cells[1], Profile = cells[2], Op = cells[3], InputsCell = cells[4], Output = cells[5], TypeText = cells[6], Line = line };
                    if (!OPS.ContainsKey(r.Op)) Fail("unsupported operation " + r.Op, line);
                    r.T = Typ(r.TypeText, line);
                    r.Effects = Names(cells[7], line);
                    r.Caps = Names(cells[8], line);
                    r.After = Names(cells[9], line);
                    long bud;
                    if (!BUDGET.IsMatch(cells[10]) || !long.TryParse(cells[10], NumberStyles.None, U.Inv, out bud)) Fail("positive budget required", line);
                    r.Budget = long.Parse(cells[10], U.Inv);
                    r.Evidence = cells[11];
                    if (r.Evidence != "none" && r.Evidence != "receipt") Fail("evidence must be none or receipt", line);
                    if (r.Op == "const") { r.Literal = Json.Parse(r.InputsCell); r.IsConst = true; r.Inputs = new List<string>(); }
                    else r.Inputs = Names(r.InputsCell, line);
                    p.Rows.Add(r);
                    if (p.Rows.Count > 1024) Fail("host row limit 1024");
                }
            }
            if (!(ended && p.Module != null && p.Sites.Count > 0 && p.Rows.Count > 0)) Fail("complete module/sites/rows/end required");
            return p;
        }

        static void CheckLiteral(object v, HType t, int line)
        {
            string k = t.Kind;
            if (k == "i64" && !(v is long)) Fail("i64 literal", line);
            if (k == "f64" && !((v is long) || (v is double && U.IsFinite((double)v)))) Fail("finite f64 literal", line);
            if (k == "text" && !(v is string)) Fail("text literal", line);
            if (k != "i64" && k != "f64" && k != "text") Fail("literals are i64, f64 or text", line);
        }

        static JObj ManifestOf(string path, string expected, string tier, int line, string relPath)
        {
            if (!File.Exists(path)) throw new HostError("line " + line.ToString(U.Inv) + ": weight set manifest not found: " + relPath);
            var m = SetFiles.ReadManifest(path);
            if (U.Sha512Text(SetFiles.SetTable(m.Arr("shards"))) != m.Str("set_sha512") || m.Str("set_sha512") != expected)
                Fail("weight set SHA-512 is not the pinned one", line);
            string stored = m.Str("tier");
            if (!(tier == stored || (tier == "TIER-0" && stored == "TIER-1"))) Fail("tier " + tier + " is not available in a " + stored + " set", line);
            return m;
        }

        static long MatrixCost(long r, long c, string tier, long rank) { return (tier == "EXACT-BF16" || tier == "TIER-2") ? r * c : rank * (r + c); }

        /// <summary>A dotted path into a report ("rail_III.admitted"); a key that itself contains dots is tried first.</summary>
        static object JPath(JObj o, string key)
        {
            if (o.Has(key)) return o.Get(key);
            object cur = o;
            foreach (string part in key.Split('.'))
            {
                var jo = cur as JObj;
                if (jo == null || !jo.Has(part)) return null;
                cur = jo.Get(part);
            }
            return cur;
        }

        /// <summary>bytes_unigram at admission: the shard list exists, every shard is a BYTES shard of the same file, and that
        /// file's LB_DATA_SHA512 is the pinned hash; the file itself is rebuilt and hashed again at load.</summary>
        static WsSpec UnigramSpec(string shardList, string pin, double alpha, string baseDir, int ln, string label)
        {
            List<object> l;
            try { l = Json.Parse(shardList) as List<object>; }
            catch (EngineError) { l = null; }
            catch (FormatException) { l = null; }
            if (l == null || l.Count == 0 || l.Any(x => !(x is string))) Fail("bytes_unigram: the shard list must be a JSON list of paths", ln);
            if (!(alpha > 0) || !U.IsFinite(alpha)) Fail("bytes_unigram: alpha must be positive", ln);
            var paths = new List<string>();
            long bytes = 0, total = -1, covered = 0;
            foreach (object o in l)
            {
                string rel = (string)o;
                string full = Path.GetFullPath(Path.Combine(baseDir, rel.Replace('/', Path.DirectorySeparatorChar)));
                if (!File.Exists(full)) throw new HostError("line " + ln.ToString(U.Inv) + ": data shard not found: " + rel);
                var head = ShardHead(full);
                string tier = null, sha = null, tb = null, nb = null;
                if (!head.TryGetValue("LB_TIER", out tier) || tier != "BYTES" || !head.TryGetValue("LB_DATA_SHA512", out sha) ||
                    !head.TryGetValue("LB_DATA_TOTAL_BYTES", out tb) || !head.TryGetValue("LB_DATA_BYTES", out nb))
                    Fail("bytes_unigram: " + rel + " is not an LB-CMD/1 BYTES shard", ln);
                if (sha != pin) Fail("bytes_unigram: the data's SHA-512 is not the pinned one", ln);
                long t = long.Parse(tb, U.Inv);
                if (total >= 0 && t != total) Fail("bytes_unigram: the shards belong to different files", ln);
                total = t;
                covered += long.Parse(nb, U.Inv);
                bytes += new FileInfo(full).Length;
                paths.Add(full);
            }
            if (covered != total) Fail("bytes_unigram: the shards do not cover the whole file", ln);
            return new WsSpec { Path = paths[0], Pin = pin, Tier = "UNIGRAM", Label = label, Bytes = bytes, Shards = paths, Alpha = alpha, DataBytes = total };
        }

        static Dictionary<string, string> ShardHead(string path)
        {
            var d = new Dictionary<string, string>(StringComparer.Ordinal);
            using (var fs = File.OpenRead(path))
            {
                var buf = new byte[4096];
                int n = fs.Read(buf, 0, buf.Length);
                string head = U.Ascii.GetString(buf, 0, n);
                int end = head.IndexOf("rem ---- payload ----", StringComparison.Ordinal);
                if (end >= 0) head = head.Substring(0, end);
                foreach (string line in head.Split(new[] { "\r\n" }, StringSplitOptions.None))
                {
                    if (!line.StartsWith("set \"", StringComparison.Ordinal) || !line.EndsWith("\"", StringComparison.Ordinal)) continue;
                    string kv = line.Substring(5, line.Length - 6);
                    int eq = kv.IndexOf('=');
                    if (eq > 0) d[kv.Substring(0, eq)] = kv.Substring(eq + 1);
                }
            }
            return d;
        }

        /// <summary>Modeled work and peak scratch of the RAILS-8S/1 operations (PROFILE-lkvexa.kgd_imq-0.2.cmd).</summary>
        static long[] RailsCost(string op, Func<int, object> c, WsSpec ws, int ln)
        {
            if (op == "json_f64") return new long[] { 1, 0 };
            if (op == "rails_parity") return new long[] { 3, 0 };
            if (op == "bytes_unigram") return new long[] { ws.Bytes, ws.DataBytes + 8 * 256 };
            JObj spec = null;
            if (op != "rails_codelen")
            {
                try { spec = Rails.SpecOf((string)c(op == "rails_witness" ? 1 : 0), op); }
                catch (EngineError e) { throw new HostError("line " + ln.ToString(U.Inv) + ": " + e.Message); }
            }
            if (op == "rails_bayes")
            {
                var h = spec.Get("hypotheses") as List<object>;
                var ev = spec.Get("evidence") as List<object> ?? new List<object>();
                if (h == null) Fail("rails_bayes: the spec needs hypotheses", ln);
                var tags = new HashSet<string>(StringComparer.Ordinal);
                foreach (object o in ev) { var e = o as JObj; var tl = e == null ? null : e.Get("tags") as List<object>; if (tl != null) foreach (object x in tl) tags.Add(x as string ?? ""); }
                long K = h.Count, E = ev.Count, D = Math.Max(1, tags.Count);
                return new long[] { K * (E + 1) + E * E * D + 1, 8 * (K + E * D) + 64 };
            }
            if (op == "rails_admit")
            {
                var it = spec.Get("items") as List<object>;
                if (it == null || it.Count == 0) Fail("rails_admit: the spec needs items", ln);
                var tags = new HashSet<string>(StringComparer.Ordinal);
                long dim = 1;
                foreach (object o in it)
                {
                    var e = o as JObj;
                    if (e == null) continue;
                    var tl = e.Get("tags") as List<object>;
                    var cl = e.Get("code") as List<object>;
                    if (tl != null) foreach (object x in tl) tags.Add(x as string ?? "");
                    if (cl != null) dim = Math.Max(dim, cl.Count);
                }
                long n = it.Count, Dd = Math.Max(dim, tags.Count);
                return new long[] { n * n * Dd + n, 8 * n * Dd };
            }
            if (op == "rails_meanfield")
            {
                var cl = spec.Get("claims") as List<object>;
                if (cl == null || cl.Count < 1 || cl.Count > 16) Fail("rails_meanfield: 1 to 16 claims", ln);
                long n = cl.Count, iters = spec.Get("max_iters") == null ? 10000 : Json.ToLong(spec.Get("max_iters"));
                if (iters < 1) Fail("rails_meanfield: max_iters must be at least 1", ln);
                return new long[] { iters * n * n + (1L << (int)n) * n * n, 8 * ((1L << (int)n) + n * n) };
            }
            bool uni = ws.Tier == "UNIGRAM";
            long perPos = 0, V = 256, H = 0;
            if (!uni)
            {
                var cfg = ws.Config;
                long d = cfg.D, kv = (long)cfg.Kv * cfg.Dk, dff = cfg.Dff;
                V = cfg.Vocab;
                H = cfg.Heads;
                long rows = cfg.EmbClusterRows > 0 ? cfg.EmbClusterRows : V;
                bool dense = ws.Tier == "EXACT-BF16" || ws.Tier == "TIER-2";
                long emb = dense ? MatrixCost(V, d, ws.Tier, ws.Rank) : ((V + rows - 1) / rows) * ws.Rank * (rows + d);
                perPos = cfg.Layers * (MatrixCost(2 * d + 2 * kv, d, ws.Tier, ws.Rank) + MatrixCost(dff, d, ws.Tier, ws.Rank) + MatrixCost(d, dff, ws.Tier, ws.Rank)) + emb;
            }
            if (op == "rails_witness")
            {
                string prompt = spec.Get("prompt") as string ?? "";
                var cands = spec.Get("candidates") as List<object>;
                if (cands == null || cands.Count < 2 || cands.Any(x => !(x is string))) Fail("rails_witness: the spec needs two or more candidates", ln);
                string cal = spec.Get("calibration") as string ?? prompt;
                long P = U.Utf8.GetByteCount(prompt), C = U.Utf8.GetByteCount(cal), sum = 0, tmax = C;
                foreach (object x in cands) { long L = U.Utf8.GetByteCount((string)x); sum += uni ? L : P + L; tmax = Math.Max(tmax, P + L); }
                if (uni) return new long[] { sum + C + 1, 8 * 256 };
                return new long[] { (sum + C) * perPos, 4 * tmax * V + 4 * H * tmax * tmax };
            }
            long n2 = U.Utf8.GetByteCount((string)c(1));
            if (uni) return new long[] { 2 * n2 * 256 + 1, 8 * 256 };
            return new long[] { (n2 + n2 * (n2 - 1) / 2) * perPos + 2 * n2 * 256, 4 * n2 * V + 4 * H * n2 * n2 };
        }

        static long[] Costs(HRow r, long T, WsSpec ws, long envN, long portParams, long portTokens, List<HType> args)
        {
            string op = r.Op;
            if (op == "const" || op == "emit" || op == "assert_eq" || op == "assert_close" || op == "assert_le" || op == "tokens_utf8" || op == "assert_json" || op == "port_count")
                return new long[] { 1, 0 };
            if (op == "port_step_account") return new long[] { envN, 0 };
            if (op.StartsWith("port_", StringComparison.Ordinal))
            {
                long n = portParams, tok = portTokens;
                long w = op == "port_build" ? n : op == "port_forward_report" ? 2 * n * tok : op == "port_first_update" ? 6 * n * tok : 6 * n * tok * Math.Max(1, envN);
                long tmp = op == "port_build" ? 4 * n : op == "port_first_update" ? 16 * n : 0;
                return new long[] { w, tmp };
            }
            if (op == "lb_load") return new long[] { ws.Bytes, 0 };
            if (op == "next_token_ce") return new long[] { T * args[0].B, 8 * T * args[0].B };
            var cfg = ws.Config;
            string tier = ws.Tier;
            long rank = ws.Rank;
            long d = cfg.D, H = cfg.Heads, dk = cfg.Dk, kv = (long)cfg.Kv * cfg.Dk, dff = cfg.Dff, V = cfg.Vocab;
            long rows = cfg.EmbClusterRows > 0 ? cfg.EmbClusterRows : V;
            bool dense = tier == "EXACT-BF16" || tier == "TIER-2";
            long emb = dense ? MatrixCost(V, d, tier, rank) : ((V + rows - 1) / rows) * rank * (rows + d);
            if (op == "embed") return new long[] { T * d * (dense ? 1 : rank), 4 * T * d };
            if (op == "attn_block") return new long[] { T * MatrixCost(2 * d + 2 * kv, d, tier, rank) + 2 * H * T * T * dk, 4 * H * T * T + 12 * T * d };
            if (op == "kgd_imq_step") return new long[] { 3 * T * T * d, 8 * T * T + 8 * T * d };
            if (op == "ffn_block") return new long[] { T * (MatrixCost(dff, d, tier, rank) + MatrixCost(d, dff, tier, rank)), 8 * T * dff };
            if (op == "head") return new long[] { T * emb, 4 * T * V };
            if (op == "greedy_bytes")
            {
                long n = envN, Tt = T + n;
                long per = Tt * (cfg.Layers * (MatrixCost(2 * d + 2 * kv, d, tier, rank) + MatrixCost(dff, d, tier, rank) + MatrixCost(d, dff, tier, rank)) + emb);
                return new long[] { n * per, 4 * Tt * V + 4 * H * Tt * Tt };
            }
            Fail("no cost model for " + op);
            return null;
        }

        static long SizeOf(HType t, object hint)
        {
            switch (t.Kind)
            {
                case "i64": case "f64": return 8;
                case "unit": return 0;
                case "text": return hint is string ? U.Utf8.GetByteCount((string)hint) : 0;
                case "Tokens": return 8 * t.A;
                case "Hidden": case "Logits": return 4 * t.A * t.B;
                default: return 0;
            }
        }

        static readonly JObj SourceDefault = new JObj().Set("vocab", 49152L).Set("d", 512L).Set("n_layers", 22L).Set("n_heads", 8L).Set("n_kv", 4L).Set("d_ff", 2048L).Set("seq_len", 2048L);

        /// <summary>MinimalLLM's shape (configs/llm_config.py at the pin) with optional JSON overrides; no KGD step.</summary>
        public static Cfg PortConfig(string spec)
        {
            var s = new JObj();
            foreach (string k in SourceDefault.Keys) s[k] = SourceDefault[k];
            if (spec != "default") { var o = (JObj)Json.Parse(spec); foreach (string k in o.Keys) s[k] = o[k]; }
            return Cfg.Make((int)s.Long("vocab"), (int)s.Long("d"), (int)s.Long("n_layers"), (int)s.Long("n_heads"), (int)s.Long("n_kv"),
                            (int)s.Long("d_ff"), (int)s.Long("seq_len"), 0.05, 1.0, false);
        }

        static JObj IrRow(HRow r)
        {
            var o = new JObj();
            o["id"] = r.Id; o["site"] = r.Site; o["profile"] = r.Profile; o["op"] = r.Op;
            o["inputs"] = r.Inputs.Cast<object>().ToList();
            o["output"] = r.Output; o["type"] = r.TypeText;
            o["effects"] = r.Effects.Cast<object>().ToList(); o["caps"] = r.Caps.Cast<object>().ToList(); o["after"] = r.After.Cast<object>().ToList();
            o["budget"] = r.Budget; o["evidence"] = r.Evidence;
            if (r.IsConst) o["literal"] = r.Literal;
            return o;
        }

        public static Compiled Compile(byte[] raw, string baseDir)
        {
            var p = Parse(raw);
            var byId = new Dictionary<string, HRow>(StringComparer.Ordinal);
            var outputs = new Dictionary<string, HRow>(StringComparer.Ordinal);
            foreach (var r in p.Rows)
            {
                if (byId.ContainsKey(r.Id)) Fail("duplicate row id", r.Line);
                byId[r.Id] = r;
                if (!p.Sites.ContainsKey(r.Site)) Fail("unknown row site", r.Line);
                var pa = OPS[r.Op];
                if (r.Profile != (string)pa[0] || r.Inputs.Count != (int)pa[1]) Fail("profile or operation arity mismatch", r.Line);
                bool terminal = r.Op == "emit" || r.Op == "assert_eq" || r.Op == "assert_close" || r.Op == "assert_le" || r.Op == "assert_json";
                if (terminal != (r.T.Is("unit") && r.Output == "-")) Fail("terminal shape mismatch", r.Line);
                if (r.Output != "-")
                {
                    if (outputs.ContainsKey(r.Output)) Fail("multiple output writers", r.Line);
                    outputs[r.Output] = r;
                }
                var eff = new HashSet<string>(StringComparer.Ordinal);
                var caps = new HashSet<string>(StringComparer.Ordinal);
                if (r.Op == "emit") { eff.Add("evidence.emit"); caps.Add("evidence.write"); }
                if (r.Op == "lb_load" || r.Op == "bytes_unigram") { eff.Add("weights.read"); caps.Add("weights.read"); }
                HashSet<string> granted;
                if (!p.Grants.TryGetValue(r.Site, out granted)) granted = new HashSet<string>();
                if (!new HashSet<string>(r.Effects).SetEquals(eff) || !new HashSet<string>(r.Caps).SetEquals(caps) || !caps.IsSubsetOf(granted))
                    Fail("effects/capability contract denied", r.Line);
                if (r.Op == "emit" && r.Evidence != "receipt") Fail("emit requires receipt", r.Line);
                if (r.IsConst) CheckLiteral(r.Literal, r.T, r.Line);
            }
            var deps = new Dictionary<string, HashSet<string>>(StringComparer.Ordinal);
            foreach (var r in p.Rows) deps[r.Id] = new HashSet<string>(r.After, StringComparer.Ordinal);
            var sets = new Dictionary<string, WsSpec>(StringComparer.Ordinal);
            var ports = new Dictionary<string, PortSpec>(StringComparer.Ordinal);
            var steps = new Dictionary<string, long>(StringComparer.Ordinal);
            var retained = new Dictionary<string, long>(StringComparer.Ordinal);
            var scratch = new Dictionary<string, long>(StringComparer.Ordinal);
            foreach (string s in p.SiteOrder) { steps[s] = 0; retained[s] = 0; scratch[s] = 0; }
            var minimum = new JObj();
            Func<string, object> konst = name => outputs[name].IsConst ? outputs[name].Literal : null;
            foreach (var r in p.Rows)
            {
                int ln = r.Line;
                string op = r.Op;
                HType t = r.T;
                var args = new List<HType>();
                foreach (string nme in r.Inputs)
                {
                    if (!outputs.ContainsKey(nme)) Fail("undefined input " + nme, ln);
                    if (outputs[nme].Site != r.Site) Fail("cross-site use needs the core fabric profile", ln);
                    deps[r.Id].Add(outputs[nme].Id);
                    args.Add(outputs[nme].T);
                }
                string kinds = string.Join(",", args.Select(a => a.Kind));
                Func<int, object> c = i => konst(r.Inputs[i]);
                if (op == "lb_load")
                {
                    if (kinds != "text,text,text" || t.Kind != "WeightSet") Fail("lb_load(text manifest, text set_sha512, text tier) -> WeightSet", ln);
                    string path = c(0) as string, pin = c(1) as string, tier = c(2) as string;
                    if (path == null || pin == null || tier == null || !TIERS.ContainsKey(tier)) Fail("lb_load takes three const texts; tier is exact, tier2, tier1 or tier0", ln);
                    string full = Path.GetFullPath(Path.Combine(baseDir, path.Replace('/', Path.DirectorySeparatorChar)));
                    var m = ManifestOf(full, pin, TIERS[tier], ln, path);
                    long rank = (TIERS[tier] == "TIER-0" || TIERS[tier] == "TIER-2") ? 2 : 10;
                    sets[r.Output] = new WsSpec { Path = full, Pin = pin, Tier = TIERS[tier], Config = Cfg.FromJson(m.Obj("config")), Bytes = m.Long("total_bytes"), Rank = rank, Label = t.Label };
                }
                else if (op == "tokens_utf8")
                {
                    string tx = c(0) as string;
                    if (kinds != "text" || t.Kind != "Tokens" || tx == null || U.Utf8.GetByteCount(tx) != t.A) Fail("tokens_utf8(const text) -> Tokens[byte length]", ln);
                }
                else if (op == "embed" || op == "head")
                {
                    if (kinds != (op == "embed" ? "Tokens,WeightSet" : "Hidden,WeightSet")) Fail(op + " operand types", ln);
                }
                else if (op == "attn_block" || op == "kgd_imq_step" || op == "ffn_block")
                {
                    if (kinds != "Hidden,WeightSet,i64" || !t.Same(args[0])) Fail(op + "(Hidden, WeightSet, i64 layer) -> same Hidden", ln);
                }
                else if (op == "next_token_ce")
                {
                    if (kinds != "Logits,Tokens" || !t.Is("f64") || args[0].A != args[1].A) Fail("next_token_ce(Logits[T,V], Tokens[T]) -> f64", ln);
                }
                else if (op == "greedy_bytes")
                {
                    if (kinds != "Tokens,WeightSet,i64" || !t.Is("text")) Fail("greedy_bytes(Tokens, WeightSet, i64 n) -> text", ln);
                }
                else if (op == "port_build")
                {
                    if (kinds != "text,i64" || t.Kind != "Port" || c(0) == null || c(1) == null) Fail("port_build(const text config, const i64 seed) -> Port", ln);
                    var pc = PortConfig((string)c(0));
                    ports[r.Output] = new PortSpec { Config = pc, Seed = Json.ToLong(c(1)), Params = Model.NParams(pc) };
                }
                else if (op == "port_count")
                {
                    string g = c(1) as string;
                    if (kinds != "Port,text" || !t.Is("i64") || (g != "all" && g != "muon" && g != "adamw")) Fail("port_count(Port, const text all|muon|adamw) -> i64", ln);
                }
                else if (op == "port_forward_report" || op == "port_first_update")
                {
                    if (kinds != "Port,text" || !t.Is("text") || c(1) == null) Fail(op + "(Port, const text token ids) -> text", ln);
                }
                else if (op == "port_loop_probe")
                {
                    if (kinds != "text,i64,i64" || !t.Is("text") || c(0) == null || c(1) == null || c(2) == null)
                        Fail("port_loop_probe(const text config, const i64 train_tokens, const i64 nan_step) -> text", ln);
                }
                else if (op == "port_step_account")
                {
                    if (kinds != "i64,i64,i64" || !t.Is("text") || c(0) == null || c(1) == null || c(2) == null)
                        Fail("port_step_account(const i64 train_tokens, const i64 batch_size, const i64 max_seq_len) -> text", ln);
                }
                else if (op == "rails_bayes" || op == "rails_admit" || op == "rails_meanfield")
                {
                    if (kinds != "text" || !t.Is("text") || !(c(0) is string)) Fail(op + "(const text spec) -> text", ln);
                }
                else if (op == "rails_parity")
                {
                    if (kinds != "text,f64,f64,f64" || !t.Is("text") || !(c(0) is string)) Fail("rails_parity(const text spec, f64, f64, f64) -> text", ln);
                }
                else if (op == "rails_witness" || op == "rails_codelen")
                {
                    if (kinds != "WeightSet,text" || !t.Is("text") || !(c(1) is string)) Fail(op + "(WeightSet, const text) -> text", ln);
                }
                else if (op == "json_f64")
                {
                    if (kinds != "text,text" || !t.Is("f64") || !(c(1) is string)) Fail("json_f64(text report, const text key) -> f64", ln);
                }
                else if (op == "bytes_unigram")
                {
                    if (kinds != "text,text,f64" || t.Kind != "WeightSet" || !(c(0) is string) || !(c(1) is string) || c(2) == null)
                        Fail("bytes_unigram(const text shard list, const text data_sha512, const f64 alpha) -> WeightSet", ln);
                    sets[r.Output] = UnigramSpec((string)c(0), (string)c(1), Json.ToDouble(c(2)), baseDir, ln, t.Label);
                }
                else if (op == "assert_json")
                {
                    if (kinds != "text,text" || c(1) == null) Fail("assert_json(text report, const text expected) -> unit", ln);
                }
                else if (op == "assert_close")
                {
                    if (kinds != "f64,f64,f64") Fail("assert_close(f64, f64, f64 tolerance)", ln);
                }
                else if (op == "assert_le")
                {
                    if (kinds != "f64,f64") Fail("assert_le(f64, f64)", ln);
                }
                else if (op == "assert_eq" && !args[0].Same(args[1])) Fail("assertion operand type mismatch", ln);
                WsSpec ws = null;
                foreach (string x in r.Inputs) if (sets.ContainsKey(x)) { ws = sets[x]; break; }
                if (op == "embed" || op == "attn_block" || op == "kgd_imq_step" || op == "ffn_block" || op == "head" || op == "greedy_bytes")
                {
                    if (ws == null || ws.Tier == "UNIGRAM") Fail("weight set must come from lb_load", ln);
                    var cfg = ws.Config;
                    if (op == "embed" && !(t.Kind == "Hidden" && t.A == args[0].A && t.B == cfg.D))
                        Fail("embed output must be Hidden[" + args[0].A.ToString(U.Inv) + "," + cfg.D.ToString(U.Inv) + "]", ln);
                    if (op == "head" && !(t.Kind == "Logits" && t.A == args[0].A && t.B == cfg.Vocab))
                        Fail("head output must be Logits[" + args[0].A.ToString(U.Inv) + "," + cfg.Vocab.ToString(U.Inv) + "]", ln);
                    if (op == "attn_block" || op == "kgd_imq_step" || op == "ffn_block")
                    {
                        object lyr = c(2);
                        if (!(lyr is long) || (long)lyr < 0 || (long)lyr >= cfg.Layers) Fail("layer index must be a const within the set's depth", ln);
                        if (args[0].B != cfg.D) Fail("hidden width differs from the weight set", ln);
                    }
                }
                long T = (args.Count > 0 && (args[0].Kind == "Tokens" || args[0].Kind == "Hidden" || args[0].Kind == "Logits")) ? args[0].A : 1;
                long envN = op == "greedy_bytes" ? Json.ToLong(c(2)) : 0, portParams = 0, portTokens = 0;
                if (op == "port_step_account") envN = CeilDivPos(Json.ToLong(c(0)), Json.ToLong(c(1)) * Json.ToLong(c(2)));
                if (op == "port_loop_probe")
                {
                    var pc = PortConfig((string)c(0));
                    envN = CeilDivPos(Json.ToLong(c(1)), PROBE_BATCH * pc.SeqLen);
                }
                if (op.StartsWith("port_", StringComparison.Ordinal) && op != "port_count" && op != "port_step_account")
                {
                    if (op == "port_build") portParams = ports[r.Output].Params;
                    else if (op == "port_loop_probe")
                    {
                        var pc = PortConfig((string)c(0));
                        portParams = Model.NParams(pc);
                        portTokens = PROBE_BATCH * pc.SeqLen;
                    }
                    else
                    {
                        PortSpec pt;
                        if (!ports.TryGetValue(r.Inputs[0], out pt)) throw new HostError("'" + r.Inputs[0] + "'");
                        portParams = pt.Params;
                        var fx = (JObj)Json.Parse((string)c(1));
                        foreach (object row in fx.Arr("ids")) portTokens += ((List<object>)row).Count;
                    }
                }
                if ((op == "rails_witness" || op == "rails_codelen") && ws == null) Fail("the witness must come from lb_load or bytes_unigram", ln);
                if (op == "rails_codelen" && ws.Tier != "UNIGRAM" && ws.Config.Vocab != 256) Fail("rails_codelen needs a byte-vocabulary witness (V = 256)", ln);
                var cost = RAILS_TEXT.Contains(op) || op == "json_f64" || op == "bytes_unigram" ? RailsCost(op, c, op == "bytes_unigram" ? sets[r.Output] : ws, ln)
                    : Costs(r, T, op != "lb_load" ? ws : sets[r.Output], envN, portParams, portTokens, args);
                long work = cost[0], temp = cost[1];
                minimum[r.Id] = work;
                if (r.Budget < work)
                    Fail("kernel work reservation below modeled minimum (" + r.Budget.ToString(U.Inv) + " < " + work.ToString(U.Inv) + ")", ln);
                steps[r.Site] += r.Budget;
                scratch[r.Site] = Math.Max(scratch[r.Site], temp);
                long size = op == "lb_load" ? sets[r.Output].Bytes : op == "port_build" ? 4 * ports[r.Output].Params : SizeOf(t, r.IsConst ? r.Literal : null);
                if (op == "port_forward_report" || op == "port_first_update" || op == "port_loop_probe" || op == "port_step_account") size = 4096;
                if (op == "greedy_bytes") size = 4 * envN;
                if (RAILS_TEXT.Contains(op)) size = 4096;
                if (op == "bytes_unigram") size = 8 * 256;
                retained[r.Site] += size;
            }
            var remaining = new HashSet<string>(byId.Keys, StringComparer.Ordinal);
            var order = new List<string>();
            while (remaining.Count > 0)
            {
                var ready = remaining.Where(x => !deps[x].Overlaps(remaining)).ToList();
                if (ready.Count == 0) Fail("dependency cycle");
                ready.Sort(string.CompareOrdinal);
                order.Add(ready[0]);
                remaining.Remove(ready[0]);
            }
            foreach (string s in p.SiteOrder)
            {
                if (steps[s] > p.Sites[s].Steps)
                    Fail("site " + s + " step reservation exceeded (" + steps[s].ToString(U.Inv) + " > " + p.Sites[s].Steps.ToString(U.Inv) + ")");
                if (retained[s] + scratch[s] > p.Sites[s].Memory)
                    Fail("site " + s + " payload plus peak scratch exceeds memory (" + (retained[s] + scratch[s]).ToString(U.Inv) + " > " + p.Sites[s].Memory.ToString(U.Inv) + ")");
            }
            var ir = new JObj();
            ir["language"] = LANGUAGE;
            ir["module"] = p.Module;
            var sitesJ = new JObj();
            foreach (string s in p.SiteOrder) sitesJ[s] = new JObj().Set("trust", p.Sites[s].Trust).Set("memory", p.Sites[s].Memory).Set("steps", p.Sites[s].Steps);
            ir["sites"] = sitesJ;
            var grantsJ = new JObj();
            foreach (string g in p.GrantOrder) { var l = p.Grants[g].ToList(); l.Sort(string.CompareOrdinal); grantsJ[g] = l.Cast<object>().ToList(); }
            ir["grants"] = grantsJ;
            ir["rows"] = order.Select(x => (object)IrRow(byId[x])).ToList();
            var adm = new JObj();
            adm["reserved_work"] = Dict(steps, p.SiteOrder);
            adm["retained_payload_bytes"] = Dict(retained, p.SiteOrder);
            adm["peak_modeled_scratch_bytes"] = Dict(scratch, p.SiteOrder);
            adm["minimum_row_work"] = minimum;
            ir["admission"] = adm;
            var wsJ = new JObj();
            foreach (var kv in sets) wsJ[kv.Key] = new JObj().Set("pin", kv.Value.Pin).Set("tier", kv.Value.Tier).Set("bytes", kv.Value.Bytes).Set("rank", kv.Value.Rank).Set("label", kv.Value.Label);
            ir["weight_sets"] = wsJ;
            ir["host"] = new JObj().Set("version", VERSION).Set("engine", "tools/KGD_ENGINE.cmd").Set("sha512", EngineSha512());
            var cmp = new Compiled { Prog = p, Ir = ir, Order = order, ById = byId, Outputs = outputs, Sets = sets, Ports = ports };
            cmp.SemanticSha512 = U.Sha512Text(Json.Canonical(ir));
            cmp.SourceSha512 = U.Sha512Hex(raw);
            return cmp;
        }

        static long CeilDivPos(long a, long b) { return a / b + (a % b != 0 ? 1 : 0); }

        static JObj Dict(Dictionary<string, long> d, List<string> order)
        {
            var o = new JObj();
            foreach (string k in order) o[k] = d[k];
            return o;
        }

        // ---------------- evaluation ----------------
        static string ShapeText(long[] s)
        {
            if (s.Length == 1) return "(" + s[0].ToString(U.Inv) + ",)";
            return "(" + string.Join(", ", s.Select(x => x.ToString(U.Inv))) + ")";
        }

        static string ResultDigest(object v, Compiled c, string rowOutput)
        {
            var a = v as Arr;
            if (a != null)
            {
                byte[] head = U.Ascii.GetBytes(ShapeText(a.Shape));
                int n = a.IsTokens ? a.Tok.Length : a.V.Length;
                var body = new byte[head.Length + 4 * n];
                Buffer.BlockCopy(head, 0, body, 0, head.Length);
                for (int i = 0; i < n; i++)
                {
                    float f = a.IsTokens ? (float)a.Tok[i] : (float)a.V[i];
                    Buffer.BlockCopy(BitConverter.GetBytes(f), 0, body, head.Length + 4 * i, 4);
                }
                return U.Sha512Hex(body);
            }
            if (v is IWeights) return c.Sets[rowOutput].Pin;
            var uw = v as UnigramWitness;
            if (uw != null) return U.Sha512Text("unigram:" + uw.DataSha512 + ":" + U.PyRepr(uw.Alpha));
            var pv = v as PortVal;
            if (pv != null)
            {
                var keys = pv.P.Names.ToList();
                keys.Sort(string.CompareOrdinal);
                using (var h = U.NewSha512())
                {
                    foreach (string k in keys)
                    {
                        var t = pv.P[k];
                        var b = new byte[4 * t.Length];
                        Buffer.BlockCopy(t, 0, b, 0, b.Length);
                        h.TransformBlock(b, 0, b.Length, null, 0);
                    }
                    h.TransformFinalBlock(new byte[0], 0, 0);
                    return U.Hex(h.Hash);
                }
            }
            return U.Sha512Text(Json.Canonical(v));
        }

        static string Repr(object v)
        {
            if (v == null) return "None";
            if (v is bool) return (bool)v ? "True" : "False";
            if (v is double) return U.PyRepr((double)v);
            if (v is string) return "'" + (string)v + "'";
            return Json.Dump(v, -1, false);
        }

        public static Dictionary<string, object> Evaluate(Compiled c, out List<object> rec, out string prev)
        {
            var vals = new Dictionary<string, object>(StringComparer.Ordinal);
            var valOrder = new List<string>();
            rec = new List<object>();
            prev = new string('0', 128);
            foreach (string rid in c.Order)
            {
                var r = c.ById[rid];
                var a = r.Inputs.Select(x => vals[x]).ToList();
                string op = r.Op;
                object v = null;
                switch (op)
                {
                    case "const": v = r.Literal; break;
                    case "lb_load": { var s = c.Sets[r.Output]; v = Loader.Load(s.Path, s.Tier, s.Pin); break; }
                    case "tokens_utf8":
                        {
                            byte[] b = U.Utf8.GetBytes((string)a[0]);
                            var tk = new long[b.Length];
                            for (int i = 0; i < b.Length; i++) tk[i] = b[i];
                            v = new Arr { IsTokens = true, Tok = tk, Shape = new long[] { b.Length } };
                            break;
                        }
                    case "embed":
                        {
                            var w = (IWeights)a[1]; var tk = (Arr)a[0];
                            v = new Arr { V = Kernels.Embed(tk.Tok, w), Shape = new long[] { 1, tk.Tok.Length, w.Config.D } };
                            break;
                        }
                    case "attn_block": case "kgd_imq_step": case "ffn_block":
                        {
                            var h = (Arr)a[0]; var w = (IWeights)a[1]; int l = (int)Json.ToLong(a[2]); int T = (int)h.Shape[1];
                            double[] y = op == "attn_block" ? Kernels.Attn(h.V, T, w, l) : op == "kgd_imq_step" ? Kernels.KgdStep(h.V, T, w, l) : Kernels.Ffn(h.V, T, w, l);
                            v = new Arr { V = y, Shape = h.Shape };
                            break;
                        }
                    case "head":
                        {
                            var h = (Arr)a[0]; var w = (IWeights)a[1]; int T = (int)h.Shape[1];
                            v = new Arr { V = Kernels.Head(h.V, T, w), Shape = new long[] { 1, T, w.Config.Vocab } };
                            break;
                        }
                    case "next_token_ce":
                        {
                            var lg = (Arr)a[0]; var tk = (Arr)a[1];
                            v = Kernels.Ce(lg.V, (int)lg.Shape[1], (int)lg.Shape[2], tk.Tok);
                            break;
                        }
                    case "greedy_bytes":
                        {
                            var tk = (Arr)a[0]; var w = (IWeights)a[1]; long n = Json.ToLong(a[2]);
                            var toks = tk.Tok.ToList();
                            int V = w.Config.Vocab, seq = w.Config.SeqLen;
                            for (long i = 0; i < n; i++)
                            {
                                var win = toks.Skip(Math.Max(0, toks.Count - seq)).ToArray();
                                var lg = Kernels.ForwardAll(win, w);
                                int last = (win.Length - 1) * V, best = 0;
                                for (int j = 1; j < 256; j++) if (lg[last + j] > lg[last + best]) best = j;
                                toks.Add(best);
                            }
                            var nb = toks.Skip(tk.Tok.Length).Select(x => (byte)x).ToArray();
                            v = U.Utf8.GetString(nb);
                            break;
                        }
                    case "port_build":
                        {
                            var ps = c.Ports[r.Output];
                            v = new PortVal { Config = ps.Config, P = Model.Init(ps.Config, Json.ToLong(a[1])) };
                            break;
                        }
                    case "port_count":
                        {
                            var pv = (PortVal)a[0]; string g = (string)a[1];
                            long s = 0;
                            foreach (string k in pv.P.Names)
                                if (g == "all" || (g == "muon") == Model.IsMuon(k)) s += pv.P[k].Length;
                            v = s;
                            break;
                        }
                    case "port_forward_report": v = PortForwardReport((PortVal)a[0], (JObj)Json.Parse((string)a[1])); break;
                    case "port_first_update": v = PortFirstUpdate((PortVal)a[0], (JObj)Json.Parse((string)a[1])); break;
                    case "port_loop_probe": v = PortLoopProbe(PortConfig((string)a[0]), Json.ToLong(a[1]), Json.ToLong(a[2])); break;
                    case "port_step_account": v = PortStepAccount(Json.ToLong(a[0]), Json.ToLong(a[1]), Json.ToLong(a[2])); break;
                    case "rails_bayes": v = Json.Dump(Rails.Bayes(Rails.SpecOf((string)a[0], op)), -1, true); break;
                    case "rails_admit": v = Json.Dump(Rails.Admit(Rails.SpecOf((string)a[0], op)), -1, true); break;
                    case "rails_meanfield": v = Json.Dump(Rails.MeanField(Rails.SpecOf((string)a[0], op)), -1, true); break;
                    case "rails_parity":
                        v = Json.Dump(Rails.Parity(Rails.SpecOf((string)a[0], op), Json.ToDouble(a[1]), Json.ToDouble(a[2]), Json.ToDouble(a[3])), -1, true);
                        break;
                    case "rails_witness": case "rails_codelen":
                        {
                            var ws = c.Sets[r.Inputs[0]];
                            var about = ws.Tier == "UNIGRAM"
                                ? new JObj().Set("kind", "unigram").Set("alpha", ws.Alpha).Set("data_sha512", ws.Pin).Set("bytes", ws.DataBytes)
                                : new JObj().Set("kind", "weights").Set("tier", ws.Tier).Set("set_sha512", ws.Pin).Set("vocab", (long)ws.Config.Vocab).Set("seq_len", (long)ws.Config.SeqLen);
                            v = Json.Dump(op == "rails_witness" ? Rails.Witness(a[0], about, Rails.SpecOf((string)a[1], op)) : Rails.CodeLen(a[0], about, (string)a[1]), -1, true);
                            break;
                        }
                    case "bytes_unigram":
                        {
                            var ws = c.Sets[r.Output];
                            byte[] data = Gen.DataUnpack(ws.Shards);
                            if (U.Sha512Hex(data) != ws.Pin) Fail("bytes_unigram: the data's SHA-512 is not the pinned one");
                            v = UnigramWitness.FromBytes(data, ws.Alpha, ws.Pin);
                            break;
                        }
                    case "json_f64":
                        {
                            object x = JPath((JObj)Json.Parse((string)a[0]), (string)a[1]);
                            if (!Json.IsNumber(x)) Fail("json_f64 at " + rid + ": " + (string)a[1] + " is not a number");
                            v = Json.ToDouble(x);
                            break;
                        }
                    case "assert_json":
                        {
                            var got = (JObj)Json.Parse((string)a[0]);
                            var want = (JObj)Json.Parse((string)a[1]);
                            foreach (string key in want.Keys)
                            {
                                object exp = want[key], val = JPath(got, key);
                                var eo = exp as JObj;
                                bool ok = (eo != null && eo.Has("center") && val != null && Json.IsNumber(val) &&
                                           Math.Abs(Json.ToDouble(val) - Json.ToDouble(eo["center"])) <= Json.ToDouble(eo["tolerance"])) || Json.PyEquals(val, exp);
                                if (!ok) Fail("assert_json fails at " + rid + ": " + key + " = " + Repr(val) + ", expected " + Repr(exp));
                            }
                            v = null;
                            break;
                        }
                    case "assert_eq":
                        if (Json.Canonical(a[0]) != Json.Canonical(a[1])) Fail("typed assertion fails at " + rid);
                        break;
                    case "assert_close":
                        {
                            double x = Json.ToDouble(a[0]), y = Json.ToDouble(a[1]), tol = Json.ToDouble(a[2]);
                            if (!(Math.Abs(x - y) <= tol)) Fail("assert_close fails at " + rid + ": " + Repr(a[0]) + " vs " + Repr(a[1]) + " (tolerance " + Repr(a[2]) + ")");
                            break;
                        }
                    case "assert_le":
                        if (!(Json.ToDouble(a[0]) <= Json.ToDouble(a[1]))) Fail("assert_le fails at " + rid + ": " + Repr(a[0]) + " > " + Repr(a[1]));
                        break;
                    case "emit": v = null; break;
                }
                if (r.Output != "-") { if (!vals.ContainsKey(r.Output)) valOrder.Add(r.Output); vals[r.Output] = v; }
                if (r.Evidence == "receipt")
                {
                    object res = op != "emit" ? v : a[0];
                    string resOut = op != "emit" ? r.Output : r.Inputs[0];
                    var body = new JObj();
                    body["scope"] = "LCUF_X_KGD_HOST_RESEARCH";
                    body["row"] = rid;
                    body["site"] = r.Site;
                    body["profile"] = r.Profile;
                    body["semantic_sha512"] = c.SemanticSha512;
                    body["previous_sha512"] = prev;
                    body["result_sha512"] = ResultDigest(res, c, resOut);
                    if (op == "emit" && !(res is Arr) && !(res is IWeights)) body["value"] = res;
                    prev = U.Sha512Text(Json.Canonical(body));
                    var full = new JObj();
                    foreach (string k in body.Keys) full[k] = body[k];
                    full["sha512"] = prev;
                    rec.Add(full);
                }
            }
            var ordered = new Dictionary<string, object>(StringComparer.Ordinal);
            foreach (string k in valOrder) ordered[k] = vals[k];
            return ordered;
        }

        // ---------------- the port checks (MinimalLLM at the pin, without the KGD step) ----------------
        static long[] Ids(JObj fx, out int B, out int T)
        {
            var rows = fx.Arr("ids");
            B = rows.Count;
            T = ((List<object>)rows[0]).Count;
            var ids = new long[B * T];
            for (int b = 0; b < B; b++)
            {
                var row = (List<object>)rows[b];
                if (row.Count != T) throw new HostError("ragged token ids");
                for (int t = 0; t < T; t++) ids[b * T + t] = Json.ToLong(row[t]);
            }
            return ids;
        }

        static string PortForwardReport(PortVal port, JObj fx)
        {
            int B, T;
            var ids = Ids(fx, out B, out T);
            double loss;
            var logits = Model.Forward(port.P, port.Config, ids, B, T, null, true, out loss, null);
            int V = port.Config.Vocab;
            bool finite = true;
            for (int i = 0; i < logits.Length; i++) if (!U.IsFinite((float)logits[i])) { finite = false; break; }
            double tot = 0;
            int cnt = 0;
            for (int b = 0; b < B; b++)
                for (int t = 0; t < T - 1; t++)
                {
                    int o = (b * T + t) * V;
                    double m = double.NegativeInfinity;
                    for (int j = 0; j < V; j++) { double x = (float)logits[o + j]; if (x > m) m = x; }
                    double z = 0;
                    for (int j = 0; j < V; j++) z += Math.Exp((float)logits[o + j] - m);
                    tot += -((float)logits[o + ids[b * T + t + 1]] - m - Math.Log(z));
                    cnt++;
                }
            var o2 = new JObj();
            o2["logits_shape"] = Json.List((long)B, (long)T, (long)V);
            o2["scored_positions"] = (long)cnt;
            o2["loss"] = tot / cnt;
            o2["finite"] = finite;
            return Json.Dump(o2, -1, true);
        }

        static string PortFirstUpdate(PortVal port, JObj fx)
        {
            int B, T;
            var ids = Ids(fx, out B, out T);
            var P = new Params();
            foreach (string k in port.P.Names) P.Add(k, port.P.Shape[k], (float[])port.P[k].Clone());
            var tr = new Trainer(P);
            int Tm = T - 1;
            var x = new long[B * Tm];
            var y = new long[B * Tm];
            for (int b = 0; b < B; b++) for (int t = 0; t < Tm; t++) { x[b * Tm + t] = ids[b * T + t]; y[b * Tm + t] = ids[b * T + t + 1]; }
            var cache = new Model.Cache();
            double loss;
            Model.Forward(P, port.Config, x, B, Tm, y, true, out loss, cache);
            var G = Model.Backward(P, port.Config, cache);
            cache = null;
            double gn = tr.Step(G);
            double change = tr.MaxChange;
            var o = new JObj();
            o["weights_unchanged_after_first_update"] = change == 0.0;
            o["max_abs_change"] = change;
            o["grad_norm"] = gn;
            o["lr_factor_first_update"] = 0.0;
            o["muon_tensors"] = (long)tr.Muon.Count;
            o["adamw_tensors"] = (long)tr.AdamW.Count;
            return Json.Dump(o, -1, true);
        }

        static string PortLoopProbe(Cfg cfg, long trainTokens, long nanStep)
        {
            var P = Model.Init(cfg, 11);
            var tr = new Trainer(P);
            var rng = Pcg64.FromSeed(5);
            int T1 = cfg.SeqLen + 1;
            var loader = new List<long[]>();
            for (int i = 0; i < PROBE_LOADER; i++) loader.Add(rng.Integers(0, cfg.Vocab, PROBE_BATCH * T1));
            long step = 0, seen = 0, nonfinite = 0;
            var read = new JObj();
            int Tm = cfg.SeqLen;
            while (seen < trainTokens)
            {
                foreach (var w in loader)
                {
                    if (seen >= trainTokens) break;
                    var x = new long[PROBE_BATCH * Tm];
                    var y = new long[PROBE_BATCH * Tm];
                    for (int b = 0; b < PROBE_BATCH; b++) for (int t = 0; t < Tm; t++) { x[b * Tm + t] = w[b * T1 + t]; y[b * Tm + t] = w[b * T1 + t + 1]; }
                    var cache = new Model.Cache();
                    double loss;
                    Model.Forward(P, cfg, x, PROBE_BATCH, Tm, y, true, out loss, cache);
                    var G = Model.Backward(P, cfg, cache);
                    if (step == nanStep)
                    {
                        loss = double.NaN;
                        foreach (string k in G.Names) { var g = G[k]; for (int i = 0; i < g.Length; i++) g[i] = float.NaN; }
                    }
                    if (!U.IsFinite(loss)) nonfinite++;
                    tr.Step(G);
                    if (step % 100 == 0) read[step.ToString(U.Inv)] = U.IsFinite(loss) ? (object)loss : "nan";
                    seen += x.Length;
                    step++;
                }
            }
            bool finite = true;
            foreach (string k in P.Names) foreach (float f in P[k]) if (float.IsNaN(f) || float.IsInfinity(f)) { finite = false; break; }
            var o = new JObj();
            o["steps_run"] = step;
            o["tokens_seen"] = seen;
            o["tokens_per_step"] = (long)(PROBE_BATCH * cfg.SeqLen);
            o["est_total_steps"] = trainTokens / (PROBE_BATCH * cfg.SeqLen);
            o["loop_completed"] = true;
            o["nonfinite_loss_steps"] = nonfinite;
            o["losses_read_at_steps"] = read;
            o["weights_finite_at_end"] = finite;
            return Json.Dump(o, -1, true);
        }

        static string PortStepAccount(long trainTokens, long batch, long seq)
        {
            long per = batch * seq, steps = 0, seen = 0;
            while (seen < trainTokens) { seen += per; steps++; }
            long total = trainTokens / per;
            long warm = Math.Max(1, (long)(total * 0.0));
            var o = new JObj();
            o["steps_run"] = steps; o["tokens_seen"] = seen; o["est_total_steps"] = trainTokens / per; o["schedule_total_steps"] = total;
            o["warmup_steps"] = warm; o["lr_factor_first_update"] = 0.0 / warm; o["optimizer_updates"] = steps;
            return Json.Dump(o, -1, true);
        }

        // ---------------- check / run ----------------
        /// <summary>The program text of a program file: an LB-DOC/1 .cmd file, or plain LCUF-X source.</summary>
        public static byte[] ProgramSource(string path)
        {
            byte[] all = File.ReadAllBytes(path);
            var info = Doc.Inspect(all);
            if (info.Ok) return info.Payload;
            if (info.Error == "no LB-DOC/1 marker line") return all;
            throw new HostError(Path.GetFileName(path) + ": " + info.Error);
        }

        public static JObj Run(string path, string mode, bool twice)
        {
            try
            {
                byte[] raw = ProgramSource(path);
                var c = Compile(raw, Path.GetDirectoryName(Path.GetFullPath(path)));
                if (mode == "check")
                    return new JObj().Set("status", "host_static_admission_pass").Set("semantic_sha512", c.SemanticSha512).Set("admission", c.Ir["admission"]);
                List<object> rec;
                string head;
                var vals = Evaluate(c, out rec, out head);
                var scalars = new JObj();
                foreach (var kv in vals)
                    if (kv.Value is long || kv.Value is double || kv.Value is string) scalars[kv.Key] = kv.Value;
                vals = null;
                GC.Collect();
                if (twice)
                {
                    List<object> rec2;
                    string head2;
                    Evaluate(c, out rec2, out head2);
                    GC.Collect();
                    if (head2 != head) Fail("second evaluation differs");
                }
                var o = new JObj();
                o["status"] = "host_research_pass";
                o["language"] = LANGUAGE;
                o["source_sha512"] = c.SourceSha512;
                o["semantic_sha512"] = c.SemanticSha512;
                o["values"] = scalars;
                o["admission"] = c.Ir["admission"];
                o["row_order"] = c.Order.Cast<object>().ToList();
                o["receipts"] = rec;
                o["receipt_chain_head"] = head;
                o["evaluated_twice"] = twice;
                o["native_cmd_execution"] = false;
                return o;
            }
            catch (EngineError e) { return new JObj().Set("status", "rejected").Set("diagnostic", e.Message); }
            catch (IOException e) { return new JObj().Set("status", "rejected").Set("diagnostic", e.Message); }
            catch (KeyNotFoundException e) { return new JObj().Set("status", "rejected").Set("diagnostic", e.Message); }
            catch (FormatException e) { return new JObj().Set("status", "rejected").Set("diagnostic", e.Message); }
            catch (InvalidCastException e) { return new JObj().Set("status", "rejected").Set("diagnostic", e.Message); }
            catch (OverflowException e) { return new JObj().Set("status", "rejected").Set("diagnostic", e.Message); }
        }
    }

    // ======== 09_programs.cs ========
    /// <summary>tools\MAKE_PROGRAMS.cmd and tools\RUN_ALL.cmd (make_programs.py and run_all.py).</summary>
    public static class Programs
    {
        const string WROOT = "../../../weights";
        const string COLS = "id | site | profile | op | inputs | output | type | effects | caps | after | budget | evidence";
        const long BIG = 1000000000000000L;
        static readonly Dictionary<string, string> SETS = new Dictionary<string, string> {
            { "m1e", "model1-untrained/exact" }, { "m1t", "model1-untrained/tier2" }, { "m2", "model2-tier1" } };
        // C089 fixtures/token-ids.json of the workspace: two rows of 16 token ids
        static readonly long[][] FIXTURE_IDS = {
            new long[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
            new long[] { 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 } };

        static string Pkg;

        static string ManifestPath(string key) { return Path.Combine(Pkg, "weights", SETS[key].Replace('/', Path.DirectorySeparatorChar), SetFiles.ManifestFile); }
        static JObj Manifest(string key) { return SetFiles.ReadManifest(ManifestPath(key)); }

        static ShardData ShardOf(string key, string shard)
        {
            var m = Manifest(key);
            foreach (object o in m.Arr("shards"))
            {
                string f = ((JObj)o).Str("file");
                if (f == "shard_" + shard + ".cmd" || f == "shard_" + shard + "_ATTN.cmd")
                    return ShardData.Read(Path.Combine(Path.GetDirectoryName(ManifestPath(key)), f), true, true);
            }
            throw new EngineError("shard " + shard + " not in " + SETS[key]);
        }

        static string Lit(object v) { return Json.Dump(v, -1, false).Replace("|", "\\u007c"); }

        static object[] Row(string id, string op, string prof, string inputs, string output, string typ, object budget = null, string effects = "-", string caps = "-", string ev = "none")
        {
            return new object[] { id, "s", prof, op, inputs, output, typ, effects, caps, "-", budget ?? "B", ev };
        }

        static object[] Const(string id, object value, string output, string typ) { return Row(id, "const", "lcuf.scalar", Lit(value), output, typ, 1L); }

        static string Cell(object c)
        {
            if (c is long) return ((long)c).ToString(U.Inv);
            if (c is int) return ((int)c).ToString(U.Inv);
            return (string)c;
        }

        static string Render(string header, string module, List<object[]> rows, long memory, long steps, string caps)
        {
            var lines = new List<string> { header, "module " + module, "site s trust=local memory=" + memory.ToString(U.Inv) + " steps=" + steps.ToString(U.Inv), "grant s caps=" + caps, COLS };
            foreach (var r in rows) lines.Add(string.Join(" | ", r.Select(Cell)));
            lines.Add("end");
            return string.Join("\n", lines) + "\n";
        }

        static List<object[]> CopyRows(List<object[]> rows) { return rows.Select(r => (object[])r.Clone()).ToList(); }

        static string KgdDir { get { return Path.Combine(Pkg, "lcufx", "programs", "kgd"); } }
        static string CoreDir { get { return Path.Combine(Pkg, "lcufx", "programs", "core"); } }

        static void WriteProgram(string dir, string name, string text, string kind)
        {
            Doc.Write(Path.Combine(dir, name + ".cmd"), name + ".lcufx", "lcufx", U.Utf8.GetBytes(text), kind);
        }

        static JObj HostCheck(string text)
        {
            try
            {
                var c = Host.Compile(U.Utf8.GetBytes(text), KgdDir);
                return new JObj().Set("status", "host_static_admission_pass").Set("admission", c.Ir["admission"]);
            }
            catch (EngineError e) { return new JObj().Set("status", "rejected").Set("diagnostic", e.Message); }
        }

        /// <summary>loose reservations -> host check -> exact reservations (each row its modeled minimum; the site the sums).</summary>
        static List<object[]> WriteExt(string name, string module, List<object[]> rows, string caps, out long mem, out long steps)
        {
            var loose = CopyRows(rows);
            foreach (var r in loose) if ((r[10] as string) == "B") r[10] = BIG;
            var res = HostCheck(Render(Host.LANGUAGE, module, loose, BIG, BIG * rows.Count, caps));
            if (res.Str("status") != "host_static_admission_pass") throw new EngineError(name + ": loose check failed: " + Json.Dump(res, -1, true));
            var adm = res.Obj("admission");
            var mrw = adm.Obj("minimum_row_work");
            var tight = CopyRows(rows);
            foreach (var r in tight) if ((r[10] as string) == "B") r[10] = mrw.Long((string)r[0]);
            mem = adm.Obj("retained_payload_bytes").Long("s") + adm.Obj("peak_modeled_scratch_bytes").Long("s");
            steps = tight.Sum(r => Json.ToLong(r[10]));
            string text = Render(Host.LANGUAGE, module, tight, mem, steps, caps);
            var res2 = HostCheck(text);
            if (res2.Str("status") != "host_static_admission_pass") throw new EngineError(name + ": tight check failed: " + Json.Dump(res2, -1, true));
            WriteProgram(KgdDir, name, text, Doc.KindKgd);
            return tight;
        }

        static List<object[]> WeightsRows(string key, string tier, string label)
        {
            var m = Manifest(key);
            return new List<object[]> {
                Const("c_path", WROOT + "/" + SETS[key] + "/" + SetFiles.ManifestFile, "path", "text"),
                Const("c_pin", m.Str("set_sha512"), "pin", "text"), Const("c_tier", tier, "tier", "text"),
                Row("w", "lb_load", "lkvexa.weights.cmd", "path,pin,tier", "W", "WeightSet[" + label + "]", null, "weights.read", "weights.read", "receipt") };
        }

        static List<object[]> ForwardRows(Cfg cfg, int T)
        {
            int d = cfg.D;
            string h = "h_e";
            var rows = new List<object[]> { Row("e", "embed", "lkvexa.llm", "ids,W", h, "Hidden[" + T + "," + d + "]") };
            for (int l = 0; l < cfg.Layers; l++)
            {
                string ls = l.ToString("00", U.Inv);
                rows.Add(Const("c_l" + ls, (long)l, "l" + ls, "i64"));
                foreach (var tp in new[] { new[] { "a", "attn_block", "lkvexa.llm" }, new[] { "k", "kgd_imq_step", "lkvexa.kgd_imq" }, new[] { "f", "ffn_block", "lkvexa.llm" } })
                {
                    string nxt = "h_" + tp[0] + ls;
                    rows.Add(Row(tp[0] + ls, tp[1], tp[2], h + ",W,l" + ls, nxt, "Hidden[" + T + "," + d + "]"));
                    h = nxt;
                }
            }
            rows.Add(Row("hd", "head", "lkvexa.llm", h + ",W", "logits", "Logits[" + T + "," + cfg.Vocab + "]"));
            rows.Add(Row("ce", "next_token_ce", "lkvexa.llm", "logits,ids", "loss", "f64", null, "-", "-", "receipt"));
            return rows;
        }

        static object[] Emit(string id, string what) { return Row(id, "emit", "lcuf.evidence", what, "-", "unit", 1L, "evidence.emit", "evidence.write", "receipt"); }

        public static byte[] Heldout(string pkg) { return Gen.DataUnpack(Gen.DataShards(Path.Combine(pkg, "data"), "heldout_bytes")); }

        static string TextWindow(int T, int start, out byte[] bytes)
        {
            byte[] held = Heldout(Pkg);
            for (int s = start; s < held.Length - T; s++)
            {
                try
                {
                    string t = U.Utf8Strict.GetString(held, s, T);
                    bytes = new byte[T];
                    Array.Copy(held, s, bytes, 0, T);
                    return t;
                }
                catch (DecoderFallbackException) { }
            }
            throw new EngineError("no UTF-8 window in the held-out text");
        }

        static double ReferenceCe(string key, byte[] b)
        {
            string tier;
            var w = Loader.Dense(ManifestPath(key), null, out tier);
            int T = b.Length - 1;
            var x = new long[T];
            var y = new long[T];
            for (int i = 0; i < T; i++) { x[i] = b[i]; y[i] = b[i + 1]; }
            double loss;
            Model.Forward(w.P, w.Config, x, 1, T, y, true, out loss, null);
            return loss;
        }

        public static JObj Make(string pkg)
        {
            Pkg = Path.GetFullPath(pkg);
            Directory.CreateDirectory(CoreDir);
            Directory.CreateDirectory(KgdDir);
            var made = new JObj();
            // ---------------- core LCUF-X/0.2 (for the user's compiler, lcuf_x.py) ----------------
            const string coreSite = "site s trust=local memory=1000000 steps=1000000", coreGrant = "grant s caps=evidence.write,optimizer.state";
            Func<string, List<object[]>, string> core = (module, rr) =>
                string.Join("\n", new[] { "LCUF-X/0.2", "module " + module, coreSite, coreGrant, COLS }.Concat(rr.Select(r => string.Join(" | ", r.Select(Cell)))).Concat(new[] { "end" })) + "\n";
            var alphas = new List<KeyValuePair<string, long>>();
            for (int l = 0; l < 4; l++)
            {
                string ls = l.ToString("00", U.Inv);
                alphas.Add(new KeyValuePair<string, long>("m1_l" + ls, ShardOf("m1e", "L" + ls).S("LB_L" + ls + "_KGD_ALPHA")));
            }
            alphas.Add(new KeyValuePair<string, long>("m2_all", ShardOf("m2", "L00").S("LB_L00_KGD_ALPHA")));
            var vec8 = new List<object> { 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };
            var rows = new List<object[]> { new object[] { "x", "s", "lcuf.scalar", "const", Lit(vec8), "x", "Vec[f64,8]", "-", "-", "-", 4096L, "none" } };
            foreach (var a in alphas)
            {
                rows.Add(new object[] { "a_" + a.Key, "s", "lcuf.scalar", "const", U.PyRepr(a.Value / 65536.0), "alpha_" + a.Key, "f64", "-", "-", "-", 4096L, "none" });
                rows.Add(new object[] { "d_" + a.Key, "s", "lcuf.diffusion.periodic", "diffuse_step", "x,alpha_" + a.Key, "y_" + a.Key, "Vec[f64,8]", "-", "-", "-", 4096L, "none" });
            }
            WriteProgram(CoreDir, "accept_kgd_alpha_gate", core("kgd_imq_alpha_gate_0", rows), Doc.KindCore);
            var aj = new JObj();
            foreach (var a in alphas) aj[a.Key] = a.Value;
            made["accept_kgd_alpha_gate"] = new JObj().Set("alphas_q16", aj);
            var over = new List<object[]> { rows[0],
                new object[] { "a_over", "s", "lcuf.scalar", "const", U.PyRepr(32769 / 65536.0), "alpha_over", "f64", "-", "-", "-", 4096L, "none" },
                new object[] { "d_over", "s", "lcuf.diffusion.periodic", "diffuse_step", "x,alpha_over", "y_over", "Vec[f64,8]", "-", "-", "-", 4096L, "none" } };
            WriteProgram(CoreDir, "reject_kgd_alpha_q16_step_above_half", core("kgd_imq_alpha_q16_step_above_half_0", over), Doc.KindCore);
            made["reject_kgd_alpha_q16_step_above_half"] = new JObj().Set("alpha_q16", 32769L);
            string t1;
            var w1 = Loader.Dense(ManifestPath("m1e"), null, out t1);
            var block = new List<object>();
            for (int j = 0; j < 256; j++) block.Add((double)w1.P["L00.qkvo"][j]);
            var zeros = new List<object>();
            for (int j = 0; j < 256; j++) zeros.Add(0L);
            var bs = new List<object[]> {
                new object[] { "x", "s", "lcuf.scalar", "const", Lit(block), "x", "Vec[f64,256]", "-", "-", "-", 4096L, "none" },
                new object[] { "r", "s", "lcuf.scalar", "const", Lit(zeros), "r", "Residual[256]", "-", "-", "-", 4096L, "none" },
                new object[] { "c", "s", "lcuf.compression.component", "ef_pack", "x,r", "bundle", "EFBundle[256]", "optimizer.local_state", "optimizer.state", "-", 4096L, "receipt" },
                new object[] { "d", "s", "lcuf.compression.component", "ef_wire", "bundle", "wire", "SignPacket[256]", "optimizer.local_state", "optimizer.state", "-", 4096L, "none" },
                new object[] { "f", "s", "lcuf.compression.component", "sign_decode", "wire", "decoded", "Vec[f64,256]", "-", "-", "-", 4096L, "none" },
                new object[] { "g", "s", "lcuf.compression.component", "ef_residual", "bundle", "residual", "Residual[256]", "optimizer.local_state", "optimizer.state", "-", 4096L, "none" } };
            WriteProgram(CoreDir, "accept_littlebit_block_sign", core("littlebit_block_sign_0", bs), Doc.KindCore);
            made["accept_littlebit_block_sign"] = new JObj().Set("source", "model 1 exact set, L00.qkvo row 0, columns 0-255 (one g = 256 block)");
            // ---------------- lkvexa.kgd_imq/0.1 ----------------
            byte[] b;
            string text = TextWindow(96, 1000, out b);
            var cfg1 = w1.Config;
            foreach (var spec in new[] { new[] { "m1e", "exact", "accept_m1_exact_forward" }, new[] { "m1t", "tier2", "accept_m1_tier2_forward" } })
            {
                double reff = ReferenceCe(spec[0], b);
                var rr = WeightsRows(spec[0], spec[1], "model1");
                rr.Add(Const("c_text", text, "text", "text"));
                rr.Add(Row("tok", "tokens_utf8", "lkvexa.bytes", "text", "ids", "Tokens[" + b.Length + "]"));
                rr.AddRange(ForwardRows(cfg1, b.Length));
                rr.Add(Const("c_ref", reff, "ref", "f64"));
                rr.Add(Const("c_tol", 1e-4, "tol", "f64"));
                rr.Add(Row("chk", "assert_close", "lkvexa.test", "loss,ref,tol", "-", "unit"));
                rr.Add(Emit("out", "loss"));
                long mem, steps;
                var tight = WriteExt(spec[2], spec[2], rr, "evidence.write,weights.read", out mem, out steps);
                made[spec[2]] = new JObj().Set("reference_ce_engine_dense_forward", reff).Set("tolerance", 1e-4).Set("tokens", (long)b.Length).Set("memory", mem).Set("steps", steps);
                if (spec[0] == "m1e")
                {
                    var under = CopyRows(tight);
                    var a00 = under.First(r => (string)r[0] == "a00");
                    a00[10] = Json.ToLong(a00[10]) - 1;
                    WriteProgram(KgdDir, "reject_m1_work_underreserve", Render(Host.LANGUAGE, "m1_work_underreserve", under, mem, steps, "evidence.write,weights.read"), Doc.KindKgd);
                    var pin = CopyRows(tight);
                    var cp = pin.First(r => (string)r[0] == "c_pin");
                    string hsh = (string)Json.Parse((string)cp[4]);
                    cp[4] = Lit((hsh[0] != '0' ? "0" : "1") + hsh.Substring(1));
                    WriteProgram(KgdDir, "reject_m1_wrong_pin", Render(Host.LANGUAGE, "m1_wrong_pin", pin, mem, steps, "evidence.write,weights.read"), Doc.KindKgd);
                    WriteProgram(KgdDir, "reject_core_header_at_kgd_host", Render("LCUF-X/0.2", "m1_core_header", tight, mem, steps, "evidence.write,weights.read"), Doc.KindKgd);
                    WriteProgram(CoreDir, "reject_kgd_imq_profile_at_core_compiler", Render(Host.LANGUAGE, spec[2], tight, mem, steps, "evidence.write,weights.read"), Doc.KindCore);
                }
            }
            string prompt = "LCUF-X/0.2 admits ";
            var dr = WeightsRows("m1e", "exact", "model1");
            dr.Add(Const("c_text", prompt, "text", "text"));
            dr.Add(Row("tok", "tokens_utf8", "lkvexa.bytes", "text", "ids", "Tokens[" + U.Utf8.GetByteCount(prompt) + "]"));
            dr.Add(Const("c_n", 64L, "n", "i64"));
            dr.Add(Row("gen", "greedy_bytes", "lkvexa.llm.decode", "ids,W,n", "continuation", "text", null, "-", "-", "receipt"));
            dr.Add(Emit("out", "continuation"));
            long dm, ds;
            WriteExt("accept_m1_exact_decode", "m1_exact_decode", dr, "evidence.write,weights.read", out dm, out ds);
            made["accept_m1_exact_decode"] = new JObj().Set("prompt", prompt).Set("new_bytes", 64L);
            var cfg2 = Cfg.FromJson(Manifest("m2").Obj("config"));
            string t2 = "KGD-IMQ ";
            foreach (string tier in new[] { "tier1", "tier0" })
            {
                string name = "accept_m2_" + tier + "_forward";
                var rr = WeightsRows("m2", tier, "model2");
                rr.Add(Const("c_text", t2, "text", "text"));
                rr.Add(Row("tok", "tokens_utf8", "lkvexa.bytes", "text", "ids", "Tokens[" + t2.Length + "]"));
                rr.AddRange(ForwardRows(cfg2, t2.Length));
                rr.Add(Const("c_cap", 1e300, "cap", "f64"));
                rr.Add(Row("fin", "assert_le", "lkvexa.test", "loss,cap", "-", "unit"));
                rr.Add(Emit("out", "loss"));
                long mem, steps;
                var tight = WriteExt(name, "m2_" + tier + "_forward", rr, "evidence.write,weights.read", out mem, out steps);
                made[name] = new JObj().Set("tokens", (long)t2.Length).Set("memory", mem).Set("steps", steps).Set("rows", (long)tight.Count);
                if (tier == "tier1")
                {
                    var bad = CopyRows(tight);
                    bad.First(r => (string)r[0] == "c_tier")[4] = Lit("tier2");
                    WriteProgram(KgdDir, "reject_m2_tier2_unavailable", Render(Host.LANGUAGE, "m2_tier2_unavailable", bad, mem, steps, "evidence.write,weights.read"), Doc.KindKgd);
                }
            }
            var fxIds = new List<object>();
            foreach (var row in FIXTURE_IDS) fxIds.Add(Json.Longs(row));
            var exp3 = new JObj().Set("logits_shape", Json.List(2L, 16L, 49152L)).Set("scored_positions", 30L)
                .Set("loss", new JObj().Set("center", 10.905).Set("tolerance", 0.25)).Set("finite", true);
            var pr = new List<object[]> { Const("c_cfg", "default", "cfgname", "text"), Const("c_seed", 0L, "seed", "i64"),
                Row("b", "port_build", "lkvexa.port", "cfgname,seed", "P", "Port[minimal_llm]") };
            foreach (var kn in new[] { new object[] { "all", 88630528L }, new object[] { "muon", 63438848L }, new object[] { "adamw", 25191680L } })
            {
                string k = (string)kn[0];
                pr.Add(Const("c_" + k, k, "group_" + k, "text"));
                pr.Add(Row("n_" + k, "port_count", "lkvexa.port", "P,group_" + k, "count_" + k, "i64"));
                pr.Add(Const("c_exp_" + k, kn[1], "exp_" + k, "i64"));
                pr.Add(Row("chk_" + k, "assert_eq", "lcuf.test", "count_" + k + ",exp_" + k, "-", "unit"));
                pr.Add(Emit("out_" + k, "count_" + k));
            }
            pr.Add(Const("c_fx", Json.Dump(new JObj().Set("ids", fxIds), -1, true), "fx", "text"));
            pr.Add(Row("fwd", "port_forward_report", "lkvexa.port", "P,fx", "report_c3", "text"));
            pr.Add(Const("c_exp3", Json.Dump(exp3, -1, true), "exp_c3", "text"));
            pr.Add(Row("chk_c3", "assert_json", "lkvexa.test", "report_c3,exp_c3", "-", "unit"));
            pr.Add(Emit("out_c3", "report_c3"));
            pr.Add(Row("upd", "port_first_update", "lkvexa.port", "P,fx", "report_c4", "text"));
            pr.Add(Const("c_exp4", Json.Dump(new JObj().Set("weights_unchanged_after_first_update", true).Set("max_abs_change", 0.0), -1, true), "exp_c4", "text"));
            pr.Add(Row("chk_c4", "assert_json", "lkvexa.test", "report_c4,exp_c4", "-", "unit"));
            pr.Add(Emit("out_c4", "report_c4"));
            long pm, psteps;
            WriteExt("accept_port_source_checks", "port_source_checks", pr, "evidence.write", out pm, out psteps);
            made["accept_port_source_checks"] = new JObj().Set("expected", new JObj().Set("C2", Json.List(88630528L, 63438848L, 25191680L)).Set("C3", exp3).Set("C4", "max_abs_change 0.0"));
            var tiny = new JObj().Set("vocab", 256L).Set("d", 64L).Set("n_layers", 2L).Set("n_heads", 2L).Set("n_kv", 1L).Set("d_ff", 256L).Set("seq_len", 32L);
            var expLoop = new JObj().Set("steps_run", 151L).Set("tokens_seen", 19328L).Set("est_total_steps", 150L).Set("loop_completed", true)
                .Set("nonfinite_loss_steps", 101L).Set("weights_finite_at_end", false);
            var lr = new List<object[]> { Const("c_tiny", Json.Dump(tiny, -1, true), "tiny", "text"), Const("c_tt", 19201L, "tt", "i64"), Const("c_ns", 50L, "ns", "i64"),
                Row("lp", "port_loop_probe", "lkvexa.port", "tiny,tt,ns", "report_loop", "text"), Const("c_explp", Json.Dump(expLoop, -1, true), "exp_loop", "text"),
                Row("chk_loop", "assert_json", "lkvexa.test", "report_loop,exp_loop", "-", "unit"), Emit("out_loop", "report_loop"),
                Const("c_b8", 8L, "b8", "i64"), Const("c_s2048", 2048L, "s2048", "i64") };
            foreach (var tt in new[] { new object[] { "t8m", 8000000L }, new object[] { "t20m", 20000000L }, new object[] { "t100m", 100000000L }, new object[] { "t1b", 1000000000L } })
            {
                string tag = (string)tt[0];
                long v = (long)tt[1], n = (v + 16383) / 16384;
                var exp = new JObj().Set("steps_run", n).Set("tokens_seen", n * 16384).Set("est_total_steps", v / 16384).Set("schedule_total_steps", v / 16384)
                    .Set("warmup_steps", 1L).Set("lr_factor_first_update", 0.0);
                lr.Add(Const("c_" + tag, v, tag, "i64"));
                lr.Add(Row("acct_" + tag, "port_step_account", "lkvexa.port", tag + ",b8,s2048", "report_" + tag, "text"));
                lr.Add(Const("c_exp_" + tag, Json.Dump(exp, -1, true), "exp_" + tag, "text"));
                lr.Add(Row("chk_" + tag, "assert_json", "lkvexa.test", "report_" + tag + ",exp_" + tag, "-", "unit"));
                lr.Add(Emit("out_" + tag, "report_" + tag));
            }
            long lm, ls2;
            WriteExt("accept_port_loop", "port_loop", lr, "evidence.write", out lm, out ls2);
            made["accept_port_loop"] = new JObj().Set("expected_loop", expLoop);
            MakeRails(made);
            Doc.WriteJson(Path.Combine(Pkg, "lcufx", "programs", "programs-made.cmd"), "programs-made.json", made);
            var listing = new JObj();
            listing["core"] = Directory.GetFiles(CoreDir, "*.cmd").Select(Path.GetFileName).OrderBy(x => x, StringComparer.Ordinal).Cast<object>().ToList();
            listing["kgd"] = Directory.GetFiles(KgdDir, "*.cmd").Select(Path.GetFileName).OrderBy(x => x, StringComparer.Ordinal).Cast<object>().ToList();
            listing["examples"] = Directory.GetFiles(Path.Combine(Pkg, "examples"), "*.cmd").Select(Path.GetFileName).OrderBy(x => x, StringComparer.Ordinal).Cast<object>().ToList();
            return listing;
        }

        // ---------------- RAILS-8S/1: the reasoning layer (REASONING-RAILS-8S.cmd) ----------------
        const string RAILS = "lkvexa.rails8s";

        static List<object[]> WeightsRowsS(string key, string tier, string label, string sfx)
        {
            var m = Manifest(key);
            return new List<object[]> {
                Const("c_path" + sfx, WROOT + "/" + SETS[key] + "/" + SetFiles.ManifestFile, "path" + sfx, "text"),
                Const("c_pin" + sfx, m.Str("set_sha512"), "pin" + sfx, "text"), Const("c_tier" + sfx, tier, "tier" + sfx, "text"),
                Row("w" + sfx, "lb_load", "lkvexa.weights.cmd", "path" + sfx + ",pin" + sfx + ",tier" + sfx, "W" + sfx, "WeightSet[" + label + "]", null, "weights.read", "weights.read", "receipt") };
        }

        static string TrainPin(out List<string> rel)
        {
            var shards = Gen.DataShards(Path.Combine(Pkg, "data"), "train_bytes");
            rel = shards.Select(x => "../../../data/" + Path.GetFileName(x)).ToList();
            return U.Sha512Hex(Gen.DataUnpack(shards));
        }

        static List<object[]> UnigramRows(string pin, List<string> rel)
        {
            return new List<object[]> {
                Const("c_shards", Json.Dump(rel.Cast<object>().ToList(), -1, true), "shards", "text"), Const("c_dpin", pin, "dpin", "text"),
                Const("c_alpha", 1.0, "alpha", "f64"),
                Row("u", "bytes_unigram", RAILS, "shards,dpin,alpha", "U", "WeightSet[unigram]", null, "weights.read", "weights.read", "receipt") };
        }

        static JObj Exp(params object[] kv)
        {
            var o = new JObj();
            for (int i = 0; i < kv.Length; i += 2) o[(string)kv[i]] = kv[i + 1];
            return o;
        }

        static JObj Near(double center, double tol) { return new JObj().Set("center", center).Set("tolerance", tol); }

        /// <summary>A rails row with its assertion and its evidence row.</summary>
        static void RailsRows(List<object[]> rows, string id, string op, string inputs, JObj expected)
        {
            rows.Add(Row(id, op, RAILS, inputs, "report_" + id, "text", null, "-", "-", "receipt"));
            rows.Add(Const("c_exp_" + id, Json.Dump(expected, -1, true), "exp_" + id, "text"));
            rows.Add(Row("chk_" + id, "assert_json", "lkvexa.test", "report_" + id + ",exp_" + id, "-", "unit"));
            rows.Add(Emit("out_" + id, "report_" + id));
        }

        static void WriteExample(string name, string op, JObj spec)
        {
            string dir = Path.Combine(Pkg, "examples");
            Directory.CreateDirectory(dir);
            Doc.Write(Path.Combine(dir, name + ".cmd"), name + ".json", "json", U.Utf8.GetBytes(Json.Dump(spec, 1, true)), Doc.KindReason + op);
        }

        static void MakeRails(JObj made)
        {
            const string caps = "evidence.write";
            const string capsW = "evidence.write,weights.read";
            long mem, steps;
            // (2.12)-(2.18) Jo's test, with the same result entered twice
            var jo = Exp("question", "Does Jo have the disease, given a positive test? MacKay (2.12)-(2.18)",
                "hypotheses", Json.List("disease", "healthy"), "prior", Json.List(0.01, 0.99),
                "evidence", Json.List(Exp("name", "positive test", "tags", Json.List("test:jo-1"), "likelihood", Json.List(0.95, 0.05)),
                                      Exp("name", "positive test, entered again", "tags", Json.List("test:jo-1"), "likelihood", Json.List(0.95, 0.05))),
                "lambda", 1.0);
            var r1 = new List<object[]> { Const("c_spec_jo", Json.Dump(jo, -1, true), "spec_jo", "text") };
            RailsRows(r1, "jo", "rails_bayes", "spec_jo", Exp("decision", "answer", "answer", "healthy", "posterior.disease", Near(19.0 / 118.0, 1e-12),
                "admitted", Json.List("positive test"), "rejected", Json.List("positive test, entered again"),
                "retraction.gates_off.posterior.disease", Near(0.009025 / (0.009025 + 0.002475), 1e-12)));
            r1.Add(Const("c_key", "posterior.disease", "key", "text"));
            r1.Add(Row("p", "json_f64", RAILS, "report_jo,key", "p_disease", "f64"));
            r1.Add(Const("c_printed", 0.16, "printed", "f64"));
            r1.Add(Const("c_tol", 0.005, "tol", "f64"));
            r1.Add(Row("chk_printed", "assert_close", "lkvexa.test", "p_disease,printed,tol", "-", "unit"));
            WriteExt("accept_rails_bayes_disease", "rails_bayes_disease", r1, caps, out mem, out steps);
            made["accept_rails_bayes_disease"] = new JObj().Set("source", "MacKay (2.12)-(2.18): P(disease | positive) = 0.95 x 0.01 / (0.95 x 0.01 + 0.05 x 0.99) = 19/118, printed as 0.16")
                .Set("expected_independent_of_the_engine", true).Set("spec", jo);
            WriteExample("rails-bayes-disease", "bayes", jo);
            // (1.18)-(1.23) the repetition code R3, f = 0.1, received 011
            var r3 = Exp("question", "Which source bit was sent, given r = 011 over a binary symmetric channel with f = 0.1? MacKay (1.18)-(1.23)",
                "hypotheses", Json.List("s=0", "s=1"), "prior", Json.List(0.5, 0.5),
                "evidence", Json.List(Exp("name", "r1=0", "tags", Json.List("bit:1"), "likelihood", Json.List(0.9, 0.1)),
                                      Exp("name", "r2=1", "tags", Json.List("bit:2"), "likelihood", Json.List(0.1, 0.9)),
                                      Exp("name", "r3=1", "tags", Json.List("bit:3"), "likelihood", Json.List(0.1, 0.9))));
            var r2 = new List<object[]> { Const("c_spec_r3", Json.Dump(r3, -1, true), "spec_r3", "text") };
            RailsRows(r2, "r3", "rails_bayes", "spec_r3", Exp("decision", "answer", "answer", "s=1", "posterior.s=1", Near(0.9, 1e-12),
                "rail_IV.margin_log_odds", Near(Math.Log(9.0), 1e-12), "rail_III.rank", 3L));
            WriteExt("accept_rails_bayes_r3", "rails_bayes_r3", r2, caps, out mem, out steps);
            made["accept_rails_bayes_r3"] = new JObj().Set("source", "MacKay (1.18)-(1.23): the likelihood ratio of r = 011 is ((1-f)/f)^(2-1) = 9, so P(s = 1 | r) = 0.9")
                .Set("expected_independent_of_the_engine", true).Set("spec", r3);
            // (3.24)-(3.27) Oliver's blood
            Func<string, double, double[], JObj> oliver = (q, lambda, lik) => Exp("question", q, "hypotheses", Json.List("present", "absent"),
                "evidence", Json.List(Exp("name", "blood types at the scene", "tags", Json.List("scene"), "likelihood", Json.List(lik[0], lik[1]))), "lambda", lambda);
            var o1 = oliver("Was Oliver one of the two people who left blood (types O and AB; Oliver is O)? MacKay (3.24)-(3.26)", 1.0, new[] { 0.01, 0.012 });
            var o4 = oliver("The same question, when a wrong answer costs four times what a right one gains", 4.0, new[] { 0.01, 0.012 });
            var oab = oliver("The same evidence for a suspect of type AB: MacKay (3.27)", 1.0, new[] { 0.6, 0.012 });
            var r4 = new List<object[]> { Const("c_spec_o1", Json.Dump(o1, -1, true), "spec_o1", "text"), Const("c_spec_o4", Json.Dump(o4, -1, true), "spec_o4", "text"),
                Const("c_spec_oab", Json.Dump(oab, -1, true), "spec_oab", "text") };
            RailsRows(r4, "o1", "rails_bayes", "spec_o1", Exp("decision", "answer", "answer", "absent", "posterior.present", Near(1.0 / 2.2, 1e-12), "rail_IV.flip_factor", Near(1.2, 1e-12)));
            RailsRows(r4, "o4", "rails_bayes", "spec_o4", Exp("decision", "abstain", "answer", null, "rail_IV.threshold", Near(0.8, 1e-15)));
            RailsRows(r4, "oab", "rails_bayes", "spec_oab", Exp("decision", "answer", "answer", "present", "posterior.present", Near(50.0 / 51.0, 1e-12),
                "rail_IV.margin_log_odds", Near(Math.Log(50.0), 1e-12)));
            WriteExt("accept_rails_bayes_oliver", "rails_bayes_oliver", r4, caps, out mem, out steps);
            made["accept_rails_bayes_oliver"] = new JObj().Set("source", "MacKay (3.24)-(3.27): likelihood ratios 1/(2 x 0.6) = 0.83 and 1/(2 x 0.01) = 50, with even prior odds")
                .Set("expected_independent_of_the_engine", true);
            // the 8S admission law on reasoning steps
            var steps6 = Exp("question", "Which of six reasoning steps add something new? (8S Theorem A: a rank-increment test)",
                "items", Json.List(Exp("name", "s1", "code", Json.List(1L, 0L, 0L), "gain_bits", 2.0), Exp("name", "s2", "code", Json.List(0L, 1L, 0L), "gain_bits", 1.0),
                    Exp("name", "s3", "code", Json.List(1L, 1L, 0L), "gain_bits", 0.7), Exp("name", "s4", "code", Json.List(0L, 0L, 1L), "gain_bits", 0.0),
                    Exp("name", "s5", "code", Json.List(1L, 1L, 0.001), "gain_bits", 0.4), Exp("name", "s6", "code", Json.List(0L, 0L, 2L), "gain_bits", 0.3)),
                "eps_ind", 0.01, "eps_gain_bits", 0.0);
            var r5 = new List<object[]> { Const("c_spec_steps", Json.Dump(steps6, -1, true), "spec_steps", "text") };
            RailsRows(r5, "steps", "rails_admit", "spec_steps", Exp("admitted", Json.List("s1", "s2", "s6"), "rejected", Json.List("s3", "s4", "s5"), "rank", 3L,
                "total_gain_bits", Near(3.3, 1e-12), "retraction.gates_off.rank", 3L));
            WriteExt("accept_rails_admit_steps", "rails_admit_steps", r5, caps, out mem, out steps);
            made["accept_rails_admit_steps"] = new JObj().Set("source", "s3 = s1 + s2 and s5 differs from s3 by 0.001 in a new direction: both fail the independence gate; s4 fails the gain gate")
                .Set("expected_independent_of_the_engine", true);
            WriteExample("rails-admit-steps", "admit", steps6);
            // the 8S gate layer on coupled claims, against exact enumeration
            var mf = Exp("question", "Three coupled claims: A supports B, B contradicts C (MacKay chapters 31 and 33)",
                "claims", Json.List("A", "B", "C"), "h", Json.List(1.2, -0.4, 0.3),
                "J", Json.List(Json.List(0L, 0.5, 0L), Json.List(0.5, 0L, -0.4), Json.List(0L, -0.4, 0L)), "lambda", 1.5);
            var r6 = new List<object[]> { Const("c_spec_mf", Json.Dump(mf, -1, true), "spec_mf", "text") };
            RailsRows(r6, "mf", "rails_meanfield", "spec_mf", Exp("certified", true, "kappa", Near(0.45, 1e-15),
                "marginals.A", Near(0.7482784821861647, 1e-12), "marginals.B", Near(0.45160463295708014, 1e-12), "marginals.C", Near(0.5809526782572996, 1e-12),
                "rail_III.meanfield.A", Near(0.759157110268757, 1e-9), "rail_III.meanfield.B", Near(0.44806394130017624, 1e-9), "rail_III.meanfield.C", Near(0.5845667072507617, 1e-9),
                "decisions.A", "accept", "decisions.B", "undecided", "decisions.C", "undecided"));
            WriteExt("accept_rails_meanfield_certified", "rails_meanfield_certified", r6, caps, out mem, out steps);
            made["accept_rails_meanfield_certified"] = new JObj().Set("source", "exact and mean-field marginals computed independently at build time (Python enumeration of the 8 states)")
                .Set("expected_independent_of_the_engine", true);
            WriteExample("rails-meanfield", "meanfield", mf);
            var mfBad = Exp("question", "Two strongly coupled claims", "claims", Json.List("A", "B"), "h", Json.List(0.1, -0.1), "J", Json.List(Json.List(0L, 2.5), Json.List(2.5, 0L)));
            var r7 = new List<object[]> { Const("c_spec_mf", Json.Dump(mfBad, -1, true), "spec_mf", "text") };
            RailsRows(r7, "mf", "rails_meanfield", "spec_mf", Exp("certified", true));
            WriteExt("reject_rails_meanfield_uncertified", "rails_meanfield_uncertified", r7, caps, out mem, out steps);
            made["reject_rails_meanfield_uncertified"] = new JObj().Set("kappa", 1.25).Set("expected", "refused: no contraction certificate");
            // witnesses: the untrained model 1, and the unigram of the training text
            byte[] cal;
            string calibration = TextWindow(64, 2000, out cal);
            var wq = Exp("question", "Which word continues the prompt?", "prompt", "Information theory and ", "candidates", Json.List("inference", "qzxjvkwbp"),
                "calibration", calibration, "lambda", 1.0);
            var r8 = WeightsRowsS("m1e", "exact", "model1", "");
            r8.Add(Const("c_spec_wq", Json.Dump(wq, -1, true), "spec_wq", "text"));
            RailsRows(r8, "wq", "rails_witness", "W,spec_wq", Exp("rail_III.admitted", false, "decision", "abstain", "answer", null));
            WriteExt("accept_rails_witness_m1_abstains", "rails_witness_m1_abstains", r8, capsW, out mem, out steps);
            made["accept_rails_witness_m1_abstains"] = new JObj().Set("expected", "the untrained model codes held-out text no better than 8 bits per byte, so it is not admitted and the layer abstains")
                .Set("spec", wq);
            List<string> rel;
            string dpin = TrainPin(out rel);
            var r9 = UnigramRows(dpin, rel);
            r9.Add(Const("c_spec_wq", Json.Dump(wq, -1, true), "spec_wq", "text"));
            RailsRows(r9, "wq", "rails_witness", "U,spec_wq", Exp("rail_III.admitted", true, "decision", "answer", "answer", "inference"));
            WriteExt("accept_rails_witness_unigram", "rails_witness_unigram", r9, capsW, out mem, out steps);
            made["accept_rails_witness_unigram"] = new JObj().Set("expected", "the unigram of the training text is admitted (it codes held-out text below 8 bits per byte) and prefers the English word; it ignores the prompt, so it is a positive control for the gate, not a reasoner")
                .Set("data_sha512", dpin);
            var wm1 = new JObj();
            foreach (string k in wq.Keys) if (k != "question") wm1[k] = wq[k];
            var wm1s = new JObj().Set("question", wq["question"]).Set("witness", new JObj().Set("manifest", "../weights/" + SETS["m1e"] + "/" + SetFiles.ManifestFile).Set("tier", "exact").Set("pin", Manifest("m1e").Str("set_sha512")));
            foreach (string k in wm1.Keys) wm1s[k] = wm1[k];
            WriteExample("rails-witness-model1", "witness", wm1s);
            var wus = new JObj().Set("question", wq["question"]).Set("witness", new JObj().Set("unigram", rel.Select(x => (object)x.Replace("../../../", "../")).ToList()).Set("data_sha512", dpin).Set("alpha", 1.0));
            foreach (string k in wm1.Keys) wus[k] = wm1[k];
            WriteExample("rails-witness-unigram", "witness", wus);
            // three routes to model 1's cross-entropy (R3 parity), with the arithmetic coder as the third route
            byte[] b48;
            string t48 = TextWindow(48, 3000, out b48);
            double ref48 = ReferenceCe("m1e", b48);
            var cfg1 = Cfg.FromJson(Manifest("m1e").Obj("config"));
            var rp = WeightsRowsS("m1e", "exact", "model1", "");
            rp.Add(Const("c_text", t48, "text", "text"));
            rp.Add(Row("tok", "tokens_utf8", "lkvexa.bytes", "text", "ids", "Tokens[" + b48.Length + "]"));
            rp.AddRange(ForwardRows(cfg1, b48.Length));
            rp.Add(Const("c_ref", ref48, "ref", "f64"));
            RailsRows(rp, "cl", "rails_codelen", "W,text", Exp("rail_I.roundtrip", true, "rail_IV.within_bound", true, "rail_III.admitted_as_compressor", false));
            rp.Add(Const("c_key", "rail_II.ce_nats", "key", "text"));
            rp.Add(Row("ce_cl", "json_f64", RAILS, "report_cl,key", "ce_codelen", "f64"));
            var ps = Exp("routes", Json.List("host forward (next_token_ce)", "dense reference (programs make)", "arithmetic-coder route (rails_codelen)"), "tolerance", 1e-4);
            rp.Add(Const("c_ps", Json.Dump(ps, -1, true), "ps", "text"));
            RailsRows(rp, "par", "rails_parity", "ps,loss,ref,ce_codelen", Exp("syndrome", "000", "corrected", false));
            rp.AddRange(WeightsRowsS("m1t", "tier2", "model1t", "2"));
            RailsRows(rp, "cl2", "rails_codelen", "W2,text", Exp("rail_I.roundtrip", true, "rail_IV.within_bound", true));
            rp.Add(Row("ce_cl2", "json_f64", RAILS, "report_cl2,key", "ce_codelen2", "f64"));
            var ps2 = Exp("routes", Json.List("host forward (next_token_ce)", "dense reference (programs make)", "arithmetic-coder route on the Tier-2 view (a wrong route)"), "tolerance", 1e-4);
            rp.Add(Const("c_ps2", Json.Dump(ps2, -1, true), "ps2", "text"));
            RailsRows(rp, "par2", "rails_parity", "ps2,loss,ref,ce_codelen2", Exp("syndrome", "011", "corrected", true, "outlier", "arithmetic-coder route on the Tier-2 view (a wrong route)"));
            WriteExt("accept_rails_parity_m1", "rails_parity_m1", rp, capsW, out mem, out steps);
            made["accept_rails_parity_m1"] = new JObj().Set("text_bytes", (long)b48.Length).Set("reference_ce_engine_dense_forward", ref48)
                .Set("expected", "three routes to the same cross-entropy agree within 1e-4; the Tier-2 route is a different model and is outvoted");
            var rq = WeightsRowsS("m1e", "exact", "model1", "");
            rq.Add(Const("c_text", t48, "text", "text"));
            rq.Add(Row("tok", "tokens_utf8", "lkvexa.bytes", "text", "ids", "Tokens[" + b48.Length + "]"));
            rq.AddRange(ForwardRows(cfg1, b48.Length));
            rq.AddRange(WeightsRowsS("m1t", "tier2", "model1t", "2"));
            rq.Add(Row("cl2", "rails_codelen", RAILS, "W2,text", "report_cl2", "text"));
            rq.Add(Const("c_key", "rail_II.ce_nats", "key", "text"));
            rq.Add(Row("ce_cl2", "json_f64", RAILS, "report_cl2,key", "ce_codelen2", "f64"));
            rq.Add(Const("c_zero", 0.0, "zero", "f64"));
            var ps3 = Exp("routes", Json.List("host forward (next_token_ce)", "arithmetic-coder route on the Tier-2 view", "a broken route that returns 0"), "tolerance", 1e-4);
            rq.Add(Const("c_ps3", Json.Dump(ps3, -1, true), "ps3", "text"));
            RailsRows(rq, "par3", "rails_parity", "ps3,loss,ce_codelen2,zero", Exp("corrected", false));
            WriteExt("reject_rails_parity_no_majority", "rails_parity_no_majority", rq, capsW, out mem, out steps);
            made["reject_rails_parity_no_majority"] = new JObj().Set("expected", "refused: no two of the three routes agree");
            var ru = UnigramRows(dpin, rel);
            ru.Add(Const("c_text", t48, "text", "text"));
            RailsRows(ru, "cl", "rails_codelen", "U,text", Exp("rail_I.roundtrip", true, "rail_IV.within_bound", true, "rail_III.admitted_as_compressor", true));
            WriteExt("accept_rails_codelen_unigram", "rails_codelen_unigram", ru, capsW, out mem, out steps);
            made["accept_rails_codelen_unigram"] = new JObj().Set("text_bytes", (long)b48.Length).Set("data_sha512", dpin);
            WriteExample("rails-codelen-model1", "codelen", new JObj().Set("question", "How many bits does the untrained model 1 need for a held-out text?")
                .Set("witness", new JObj().Set("manifest", "../weights/" + SETS["m1e"] + "/" + SetFiles.ManifestFile).Set("tier", "exact").Set("pin", Manifest("m1e").Str("set_sha512")))
                .Set("text", t48));
        }

        // ---------------- run every program and record the evidence ----------------
        static JObj RunCore(string coreCompilerDir, string programPath, out int code)
        {
            code = 3;
            string tmp = Path.Combine(Path.GetTempPath(), "lkvexa-core-" + Guid.NewGuid().ToString("N"));
            Directory.CreateDirectory(tmp);
            string src = Path.Combine(tmp, Path.GetFileNameWithoutExtension(programPath) + ".lcufx");
            File.WriteAllBytes(src, Doc.Read(programPath));
            try
            {
                string py = Environment.GetEnvironmentVariable("LCUF_PYTHON") ?? "python";
                const string boot = "import sys,runpy; d=sys.argv[1]; sys.path.insert(0,d); sys.argv=[d+'\\\\lcuf_x.py']+sys.argv[2:]; runpy.run_path(sys.argv[0], run_name='__main__')";
                var psi = new ProcessStartInfo(py, "-I -B -c \"" + boot + "\" \"" + coreCompilerDir + "\" run \"" + src + "\"")
                { UseShellExecute = false, RedirectStandardOutput = true, RedirectStandardError = true, CreateNoWindow = true, WorkingDirectory = tmp };
                using (var p = Process.Start(psi))
                {
                    string so = p.StandardOutput.ReadToEnd(), se = p.StandardError.ReadToEnd();
                    p.WaitForExit();
                    code = p.ExitCode;
                    try { return (JObj)Json.Parse(so); }
                    catch (Exception) { return new JObj().Set("status", "unparsed").Set("stdout_tail", Tail(so, 400)).Set("stderr_tail", Tail(se, 800)); }
                }
            }
            catch (Exception e) { return new JObj().Set("status", "error").Set("diagnostic", "could not run the core compiler: " + e.Message); }
            finally { try { Directory.Delete(tmp, true); } catch (Exception) { } }
        }

        static string Tail(string s, int n) { return s.Length <= n ? s : s.Substring(s.Length - n); }

        public static JObj RunAll(string pkg, string ev, HashSet<string> only, HashSet<string> skip, string coreCompiler)
        {
            Pkg = Path.GetFullPath(pkg);
            string outd = Path.Combine(ev, "programs");
            Directory.CreateDirectory(outd);
            string engine = Host.EngineSha512();
            foreach (string kind in new[] { "core", "kgd" })
            {
                var files = Directory.GetFiles(Path.Combine(Pkg, "lcufx", "programs", kind), "*.cmd").Select(Path.GetFileName).OrderBy(x => x, StringComparer.Ordinal);
                foreach (string f in files)
                {
                    string name = f.Substring(0, f.Length - 4);
                    if ((only != null && !only.Contains(name)) || skip.Contains(name)) continue;
                    string path = Path.Combine(Pkg, "lcufx", "programs", kind, f);
                    var sw = Stopwatch.StartNew();
                    JObj outp;
                    int code;
                    string runner;
                    if (kind == "core")
                    {
                        runner = "lcuf_x.py (the user's LCUF-X/0.2 compiler)";
                        if (coreCompiler == null) { outp = new JObj().Set("status", "not_run").Set("note", "pass --core LCUF_X_DIR (the folder of lcuf_x.py) to run it"); code = -1; }
                        else outp = RunCore(coreCompiler, path, out code);
                    }
                    else
                    {
                        runner = "lcufx\\LCUFX_KGD.cmd run --twice (tools\\KGD_ENGINE.cmd host)";
                        outp = Host.Run(path, "run", true);
                        code = outp.Str("status") == "host_research_pass" ? 0 : 2;
                    }
                    sw.Stop();
                    string expected = name.StartsWith("accept_", StringComparison.Ordinal) ? "accept" : "reject";
                    string st = outp.Get("status") as string;
                    string got = (code == 0 && st == "host_research_pass") ? "accept" : st == "rejected" ? "reject" : st == "not_run" ? "not_run" : "error";
                    var rec = new JObj();
                    rec["program"] = kind + "/" + f;
                    rec["source_sha512"] = U.Sha512Hex(Doc.Read(path));
                    rec["file_sha512"] = U.Sha512File(path);
                    rec["runner"] = runner;
                    rec["expected"] = expected;
                    rec["observed"] = got;
                    rec["as_expected"] = got == expected;
                    rec["exit_code"] = (long)code;
                    rec["seconds"] = Math.Round(sw.Elapsed.TotalSeconds, 1);
                    rec["output"] = outp;
                    Doc.WriteJson(Path.Combine(outd, name + ".cmd"), name + ".json", rec);
                    Console.Error.WriteLine(kind + "/" + name + ": expected " + expected + ", observed " + got + ", " + U.PyRepr(Math.Round(sw.Elapsed.TotalSeconds, 1)) + "s");
                }
            }
            var runs = new JObj();
            var notRun = new List<object>();
            foreach (string f in Directory.GetFiles(outd, "*.cmd").Select(Path.GetFileName).OrderBy(x => x, StringComparer.Ordinal))
            {
                var r = (JObj)Doc.ReadJson(Path.Combine(outd, f));
                var o = r.Obj("output");
                var x = new JObj();
                foreach (string k in new[] { "program", "source_sha512", "runner", "expected", "observed", "as_expected", "exit_code", "seconds" }) x[k] = r[k];
                if (r.Str("observed") == "reject") x["diagnostic"] = o.Get("diagnostic");
                else if (r.Str("observed") == "accept") x["receipt_chain_head"] = o.Get("receipt_chain_head");
                if (r.Str("observed") == "not_run") notRun.Add(r["program"]);
                if (r.Str("observed") == "accept" && r.Str("program").StartsWith("kgd/", StringComparison.Ordinal))
                {
                    var vals = new JObj();
                    var ov = o.Obj("values");
                    foreach (string k in ov.Keys)
                        if (k == "loss" || k == "continuation" || k.StartsWith("count_", StringComparison.Ordinal) || k.StartsWith("report_", StringComparison.Ordinal)) vals[k] = ov[k];
                    x["values"] = vals;
                }
                runs[f.Substring(0, f.Length - 4)] = x;
            }
            bool allRan = true;
            foreach (string k in runs.Keys) { var x = runs.Obj(k); if (x.Str("observed") != "not_run" && !(bool)x["as_expected"]) allRan = false; }
            var summary = new JObj();
            summary["runs"] = runs;
            summary["all_run_as_expected"] = allRan;
            summary["programs"] = (long)runs.Count;
            summary["not_run"] = notRun;
            summary["core_compiler"] = coreCompiler == null ? null : (object)new JObj()
                .Set("lcuf_x.py", File.Exists(Path.Combine(coreCompiler, "lcuf_x.py")) ? U.Sha512File(Path.Combine(coreCompiler, "lcuf_x.py")) : null)
                .Set("math_kernels.py", File.Exists(Path.Combine(coreCompiler, "math_kernels.py")) ? U.Sha512File(Path.Combine(coreCompiler, "math_kernels.py")) : null);
            summary["kgd_host"] = new JObj().Set("version", Host.VERSION).Set("engine_sha512", engine);
            Doc.WriteJson(Path.Combine(ev, "programs-summary.cmd"), "programs-summary.json", summary);
            return new JObj().Set("all_run_as_expected", allRan).Set("programs", (long)runs.Count).Set("not_run", notRun);
        }
    }

    // ======== 10_checks.cs ========
    /// <summary>tools\CHECKS.cmd and tools\PACKAGE.cmd: the gradient check, the factored-path check, size bounds, the package manifest.</summary>
    public static class Checks
    {
        /// <summary>finite differences against the analytic gradients (grad_check.py), double arithmetic on a tiny configuration.</summary>
        public static JObj Grad()
        {
            var cfg = Cfg.Make(17, 16, 2, 4, 2, 24, 6, 0.2, 0.7, true);
            var P = Model.Init(cfg, 7);
            var rng = Pcg64.FromSeed(3);
            foreach (string k in P.Names)
            {
                var v = P[k];
                if (P.Shape[k].Length <= 1) for (int i = 0; i < v.Length; i++) v[i] = (float)(v[i] + 0.1 * rng.StandardNormal());
                else for (int i = 0; i < v.Length; i++) v[i] = v[i] * 10f;
            }
            var tok = rng.Integers(0, cfg.Vocab, 2 * 7);
            var x = new long[12];
            var y = new long[12];
            for (int b = 0; b < 2; b++) for (int t = 0; t < 6; t++) { x[b * 6 + t] = tok[b * 7 + t]; y[b * 6 + t] = tok[b * 7 + t + 1]; }
            var cache = new Model.Cache();
            double loss;
            Model.Forward(P, cfg, x, 2, 6, y, false, out loss, cache);
            var G = Model.Backward(P, cfg, cache);
            var per = new JObj();
            double worst = 0;
            foreach (string k in P.Names)
            {
                var v = P[k];
                var picks = new List<int>();
                int want = Math.Min(6, v.Length);
                while (picks.Count < want) { int i = (int)rng.Integer(0, v.Length); if (!picks.Contains(i)) picks.Add(i); }
                double mx = 0;
                foreach (int i in picks)
                {
                    float old = v[i];
                    double lp, lm;
                    v[i] = (float)(old + 1e-6);
                    double hp = (double)v[i] - old;
                    Model.Forward(P, cfg, x, 2, 6, y, false, out lp, null);
                    v[i] = (float)(old - 1e-6);
                    double hm = old - (double)v[i];
                    Model.Forward(P, cfg, x, 2, 6, y, false, out lm, null);
                    v[i] = old;
                    // central difference with the actual (float32-representable) steps; second order in h
                    double num = (lp - lm) / (hp + hm);
                    double ana = G[k][i];
                    double err = Math.Abs(num - ana) / Math.Max(1e-8, Math.Abs(num) + Math.Abs(ana));
                    mx = Math.Max(mx, err);
                }
                per[k] = mx;
                worst = Math.Max(worst, mx);
            }
            var r = new JObj();
            r["config"] = cfg.Json;
            r["loss"] = loss;
            r["method"] = "central differences with steps of 1e-6 (the float32-representable step actually taken), double arithmetic, against the backward pass";
            r["max_relative_error_per_tensor"] = per;
            r["worst"] = worst;
            r["pass"] = worst < 1e-5;
            r["threshold"] = 1e-5;
            return r;
        }

        static int[] PackPadded(double[] s)
        {
            var w = new int[(s.Length + 31) / 32];
            for (int i = 0; i < s.Length; i++) if (s[i] > 0) w[i >> 5] |= 1 << (i & 31);
            return w;
        }

        static double[] Dense(Factored F)
        {
            var I = new double[F.C * F.C];
            for (int j = 0; j < F.C; j++) I[j * F.C + j] = 1;
            var y = F.Apply(I, F.C);
            var W = new double[F.Rows * F.C];
            for (int j = 0; j < F.C; j++) for (int i = 0; i < F.Rows; i++) W[i * F.C + j] = y[j * F.Rows + i];
            return W;
        }

        /// <summary>validate_factored.py: the algebra of the factored operator, and a small set in model 2's format end to end.</summary>
        public static JObj FactoredPath(string smallDir)
        {
            var rng = Pcg64.FromSeed(3);
            int r = 48, c = 40, R = 8;
            Func<int, double[]> sgn = n => { var a = new double[n]; for (int i = 0; i < n; i++) a[i] = rng.Integer(0, 2) == 0 ? -1.0 : 1.0; return a; };
            double[] u1 = sgn(r), u2 = sgn(r), v1 = sgn(c), v2 = sgn(c);
            var du = new double[R][]; var dv = new double[R][];
            for (int p = 0; p < R; p++) { du[p] = sgn(r); dv[p] = sgn(c); }
            var sr = new float[r]; var sc = new float[c]; var A = new float[R];
            for (int i = 0; i < r; i++) sr[i] = (float)rng.Uniform(0.1, 1);
            for (int j = 0; j < c; j++) sc[j] = (float)rng.Uniform(0.1, 1);
            for (int p = 0; p < R; p++) A[p] = (float)(0.1 * rng.StandardNormal());
            var F = new Factored { R = r, C = c, Row0 = 0, Rows = r, U1 = PackPadded(u1), U2 = PackPadded(u2), V1 = PackPadded(v1), V2 = PackPadded(v2), Sr = sr, Sc = sc, A = A,
                                   Du = du.Select(PackPadded).ToArray(), Dv = dv.Select(PackPadded).ToArray() };
            var W = new double[r * c];
            double scale = 0;
            for (int i = 0; i < r; i++)
                for (int j = 0; j < c; j++)
                {
                    double v = sr[i] * (u1[i] * v1[j] + u2[i] * v2[j]) * sc[j];
                    for (int p = 0; p < R; p++) v += du[p][i] * A[p] * dv[p][j];
                    W[i * c + j] = v;
                    scale = Math.Max(scale, Math.Abs(v));
                }
            var x = new double[5 * c];
            for (int i = 0; i < x.Length; i++) x[i] = rng.StandardNormal();
            Func<double[], int, int, double> diff = (y, a, b) =>
            {
                double m = 0;
                for (int n = 0; n < 5; n++) for (int i = a; i < b; i++)
                {
                    double s = 0;
                    for (int j = 0; j < c; j++) s += x[n * c + j] * W[i * c + j];
                    m = Math.Max(m, Math.Abs(y[n * (b - a) + (i - a)] - s));
                }
                return m;
            };
            double rv = 0;
            foreach (int idx in new[] { 0, 7, 47 })
            {
                var row = F.RowVector(idx);
                for (int j = 0; j < c; j++) rv = Math.Max(rv, Math.Abs(row[j] - W[idx * c + j]));
            }
            var alg = new JObj();
            alg["apply"] = diff(F.Apply(x, 5), 0, r);
            alg["rows_10_30"] = diff(F.View(10, 30).Apply(x, 5), 10, 30);
            alg["row_vectors"] = rv;
            alg["rank_bound"] = (long)F.RankBound;
            alg["scale_of_W"] = scale;
            // end to end: a small set in model 2's format, the host's factored path against the dense forward pass
            Gen.Model2(smallDir, 256, 2, 7, false);
            string man = Path.Combine(smallDir, SetFiles.ManifestFile);
            var sm = SetFiles.ReadManifest(man);
            var e2e = new JObj();
            e2e["set"] = new JObj().Set("d", 256L).Set("n_layers", 2L).Set("vocab", 49152L).Set("set_sha512", sm["set_sha512"]);
            var tokens = U.Ascii.GetBytes("KGD-IMQ LittleBit").Select(bb => (long)bb).ToArray();
            bool pass = Math.Max(Json.ToDouble(alg["apply"]), Math.Max(Json.ToDouble(alg["rows_10_30"]), rv)) < 1e-5 * Math.Max(1.0, scale);
            foreach (string tier in new[] { "TIER-1", "TIER-0" })
            {
                var fw = Loader.FactoredSet(man, tier, sm.Str("set_sha512"));
                var host = Kernels.ForwardAll(tokens, fw);
                var cfg = fw.Cfg;
                var P = new Params();
                int rows = cfg.EmbClusterRows, d = cfg.D;
                var emb = new float[cfg.Vocab * d];
                for (int cl = 0; cl < fw.Emb.Count; cl++)
                    for (int i = 0; i < rows; i++)
                    {
                        var rvv = fw.Emb[cl].RowVector(i);
                        for (int j = 0; j < d; j++) emb[(cl * rows + i) * d + j] = (float)rvv[j];
                    }
                var shapes = new Dictionary<string, int[]>();
                foreach (var kv in Model.Shapes(cfg)) shapes[kv.Key] = kv.Value;
                P.Add("emb", shapes["emb"], emb);
                for (int l = 0; l < cfg.Layers; l++)
                {
                    string p = Model.Lp(l);
                    P.Add(p + "n1", shapes[p + "n1"], fw.V[p + "n1"]);
                    P.Add(p + "qkvo", shapes[p + "qkvo"], Dense(fw.W[p + "qkvo"]).Select(z => (float)z).ToArray());
                    P.Add(p + "qn", shapes[p + "qn"], fw.V[p + "qn"]);
                    P.Add(p + "kn", shapes[p + "kn"], fw.V[p + "kn"]);
                    P.Add(p + "n2", shapes[p + "n2"], fw.V[p + "n2"]);
                    P.Add(p + "up", shapes[p + "up"], Dense(fw.W[p + "up"]).Select(z => (float)z).ToArray());
                    P.Add(p + "down", shapes[p + "down"], Dense(fw.W[p + "down"]).Select(z => (float)z).ToArray());
                    double alpha, cc;
                    fw.Kgd(l, out alpha, out cc);
                    P.Add(p + "ka", new int[0], new[] { (float)Math.Log(2 * alpha / (1 - 2 * alpha)) });
                    P.Add(p + "kb", new int[0], new[] { (float)Math.Log(FdLibm.Expm1(cc)) });
                }
                P.Add("fn", shapes["fn"], fw.V["fn"]);
                double loss;
                var refl = Model.Forward(P, cfg, tokens, 1, tokens.Length, null, true, out loss, null);
                double md = 0, ml = 0;
                for (int i = 0; i < host.Length; i++) { md = Math.Max(md, Math.Abs(host[i] - (float)refl[i])); ml = Math.Max(ml, Math.Abs(refl[i])); }
                var te = new JObj();
                te["max_abs_diff_logits"] = md;
                te["max_abs_logit"] = ml;
                te["host_ce"] = Kernels.Ce(host, tokens.Length, cfg.Vocab, tokens);
                te["dense_ce"] = Kernels.Ce(refl, tokens.Length, cfg.Vocab, tokens);
                te["tokens"] = (long)tokens.Length;
                e2e[tier] = te;
                pass &= md <= 1e-4 * Math.Max(1.0, ml);
            }
            var res = new JObj();
            res["algebra"] = alg;
            res["end_to_end_small_model2_format_set"] = e2e;
            res["pass"] = pass;
            return res;
        }

        /// <summary>size_drift.py without model 1's trained lengths (model 1 is untrained): model 2's files now and at the bound.</summary>
        public static JObj SizeDrift(string pkg)
        {
            string dir = Path.Combine(pkg, "weights", "model2-tier1");
            var m = SetFiles.ReadManifest(Path.Combine(dir, SetFiles.ManifestFile));
            var per = new List<object>();
            long now = 0, bound = 0, mxNow = 0, mxBound = 0, over = 0;
            var cats = new Dictionary<string, long[]>();
            foreach (object o in m.Arr("shards"))
            {
                var s = (JObj)o;
                var sd = ShardData.Read(Path.Combine(dir, s.Str("file")), true, true);
                foreach (string f in sd.FamOrder)
                {
                    string cat = Category(f);
                    long[] cv;
                    if (!cats.TryGetValue(cat, out cv)) cats[cat] = cv = new long[2];
                    foreach (int v in sd.Fam[f]) { cv[0]++; cv[1] += v.ToString(U.Inv).Length; }
                }
                long[] sv;
                if (!cats.TryGetValue("scalar", out sv)) cats["scalar"] = sv = new long[2];
                foreach (var kv in sd.Scal) { sv[0]++; sv[1] += kv.Value.ToString(U.Inv).Length; }
                now += sd.Bytes; bound += sd.BoundAnyValues;
                mxNow = Math.Max(mxNow, sd.Bytes); mxBound = Math.Max(mxBound, sd.BoundAnyValues);
                if (sd.BoundAnyValues > Gen.ShardCap) over++;
                per.Add(new JObj().Set("file", s["file"]).Set("bytes_now", sd.Bytes).Set("bytes_bound", sd.BoundAnyValues));
            }
            var mean = new JObj();
            var counts = new JObj();
            foreach (var kv in cats.OrderBy(k => k.Key, StringComparer.Ordinal))
            {
                if (kv.Value[0] == 0) continue;
                mean[kv.Key] = Math.Round((double)kv.Value[1] / kv.Value[0], 3);
                counts[kv.Key] = kv.Value[0];
            }
            var r = new JObj();
            r["model2_now"] = new JObj().Set("total", now).Set("largest", mxNow);
            r["model2_bound_every_value_11_chars"] = new JObj().Set("total", bound).Set("largest", mxBound).Set("shards_over_24000000", over);
            r["shard_cap"] = Gen.ShardCap;
            r["mean_chars_per_value_model2_init"] = mean;
            r["values_per_category_model2"] = counts;
            r["note"] = "training changes values, never how many words a set holds; a value is 1 to 11 characters, so the bound is the most any training can add";
            r["shards"] = per;
            return r;
        }

        static string Category(string fam)
        {
            if (Regex.IsMatch(fam, @"_(U1|V1|U2|V2|S|D\d\dU|D\d\dV)$")) return "sign";
            if (Regex.IsMatch(fam, @"_(SR|SC|B)$")) return "scale";
            if (fam.EndsWith("_W", StringComparison.Ordinal)) return "bf16";
            return "q16";
        }

        /// <summary>Writing one worst-case shard (every value -2147483648) reproduces the computed bound.</summary>
        public static JObj SizeBound(string pkg, string tmpDir)
        {
            string rel = "weights/model1-untrained/tier2/shard_EMB.cmd";
            string path = Path.Combine(pkg, rel.Replace('/', Path.DirectorySeparatorChar));
            var sd = ShardData.Read(path, true, true);
            var w = new ShardWriter();
            byte[] data = File.ReadAllBytes(path);
            string headText = U.Ascii.GetString(data, 0, U.IndexOf(data, U.Ascii.GetBytes("rem ---- payload ----\r\n"), 0));
            var lines = headText.Split(new[] { "\r\n" }, StringSplitOptions.None);
            w.Comment = new[] { lines[1], lines[2] };
            foreach (string line in lines.Skip(3))
            {
                if (!line.StartsWith("set \"", StringComparison.Ordinal)) continue;
                string kv = line.Substring(5, line.Length - 6);
                int eq = kv.IndexOf('=');
                string k = kv.Substring(0, eq);
                if (k == "LB_PAYLOAD_LINES" || k == "LB_PAYLOAD_SHA512" || k == "LB_L1_CHECKSUM") continue;
                w.H(k, kv.Substring(eq + 1));
            }
            // rebuild the payload in file order with every value at its most negative
            int p = U.IndexOf(data, U.Ascii.GetBytes("rem ---- payload ----\r\n"), 0) + 23;
            int end = U.IndexOf(data, U.Ascii.GetBytes("rem ---- end of payload ----\r\n"), p);
            string payload = U.Ascii.GetString(data, p, end - p);
            foreach (string line in payload.Split(new[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries))
            {
                string key = line.Substring(5, line.IndexOf('=') - 5);
                w.AppendRaw("set \"" + key + "=-2147483648\"\r\n", 2147483648L);
            }
            string outp = Path.Combine(tmpDir, "worst_case_shard_EMB.cmd");
            Directory.CreateDirectory(tmpDir);
            w.Write(outp);
            long worst = new FileInfo(outp).Length;
            var back = ShardData.Read(outp, false, false);
            var r = new JObj();
            r["shard"] = rel;
            r["bytes_now"] = sd.Bytes;
            r["computed_bound"] = sd.BoundAnyValues;
            r["worst_case_file_bytes"] = worst;
            r["worst_case_file_reads_back"] = back.PayloadShaOk && back.LinesOk && back.L1Ok;
            r["method"] = "every payload value replaced by -2147483648, LB_L1_CHECKSUM set to lines x 2^31, payload SHA-512 recomputed";
            r["bound_equals_worst_case"] = worst == sd.BoundAnyValues;
            try { File.Delete(outp); } catch (Exception) { }
            return r;
        }

        // ---------------- the package manifest ----------------
        public const string PackageManifest = "PACKAGE-MANIFEST.cmd";

        public static List<string> Files(string pkg)
        {
            string root = Path.GetFullPath(pkg).TrimEnd('\\', '/');
            var l = new List<string>();
            foreach (string f in Directory.GetFiles(root, "*", SearchOption.AllDirectories))
            {
                string rel = f.Substring(root.Length + 1).Replace('\\', '/');
                if (rel.StartsWith(".git/", StringComparison.Ordinal) || rel == PackageManifest) continue;
                l.Add(rel);
            }
            l.Sort(string.CompareOrdinal);
            return l;
        }

        public static JObj PackageWrite(string pkg, string combinedSha)
        {
            var files = new List<object>();
            foreach (string rel in Files(pkg))
            {
                string p = Path.Combine(pkg, rel.Replace('/', Path.DirectorySeparatorChar));
                files.Add(new JObj().Set("path", rel).Set("bytes", new FileInfo(p).Length).Set("sha512", U.Sha512File(p)));
            }
            var m = new JObj();
            m["package"] = "lkvexa-kgd-imq-5dllm";
            m["edition"] = ".cmd only";
            m["combined_weights_sha512"] = combinedSha;
            m["rule"] = "every file of the repository except this one and .git/, sorted by path; every file is a .cmd file except README.md and .gitattributes";
            m["files"] = files;
            Doc.WriteJson(Path.Combine(pkg, PackageManifest), "package-manifest.json", m);
            return new JObj().Set("files", (long)files.Count);
        }

        public static JObj PackageVerify(string pkg)
        {
            var m = (JObj)Doc.ReadJson(Path.Combine(pkg, PackageManifest));
            var listed = new Dictionary<string, JObj>(StringComparer.Ordinal);
            foreach (object o in m.Arr("files")) listed[((JObj)o).Str("path")] = (JObj)o;
            var present = Files(pkg);
            var changed = new List<object>();
            var missing = new List<object>();
            var added = new List<object>();
            var notCmd = new List<object>();
            var big = new List<object>();
            foreach (string rel in present)
            {
                string p = Path.Combine(pkg, rel.Replace('/', Path.DirectorySeparatorChar));
                long len = new FileInfo(p).Length;
                if (len > Gen.ShardCap) big.Add(rel);
                if (!rel.EndsWith(".cmd", StringComparison.Ordinal) && rel != "README.md" && rel != ".gitattributes") notCmd.Add(rel);
                JObj e;
                if (!listed.TryGetValue(rel, out e)) { added.Add(rel); continue; }
                if (e.Long("bytes") != len || e.Str("sha512") != U.Sha512File(p)) changed.Add(rel);
            }
            foreach (string rel in listed.Keys) if (!present.Contains(rel)) missing.Add(rel);
            var r = new JObj();
            r["files_listed"] = (long)listed.Count;
            r["files_present"] = (long)present.Count;
            r["changed"] = changed; r["missing"] = missing; r["added"] = added;
            r["not_cmd"] = notCmd; r["over_24000000_bytes"] = big;
            r["pass"] = changed.Count == 0 && missing.Count == 0 && added.Count == 0 && notCmd.Count == 0 && big.Count == 0;
            return r;
        }

        // ---------------- self-test: values computed with numpy and Python on the build machine ----------------
        public static JObj SelfTest(JObj expect)
        {
            var r = new JObj();
            bool all = true;
            Action<string, object, object> eq = (name, got, want) =>
            {
                bool ok = Json.PyEquals(got, want) || (got is string && want is string && (string)got == (string)want);
                r[name] = new JObj().Set("ok", ok).Set("got", got).Set("want", want);
                all &= ok;
            };
            var g = Pcg64.FromSeed(2026);
            var raw = new List<object>();
            for (int i = 0; i < 4; i++) raw.Add(g.Next64().ToString(U.Inv));
            eq("pcg64_2026_next64", raw, expect["pcg64_2026_next64"]);
            var h = Pcg64.FromText("2026:LB_L00_QKVO_U1");
            eq("sign_words_L00_QKVO_U1", Json.Longs(Enumerable.Range(0, 6).Select(i => h.Integer(-2147483648L, 2147483648L))), expect["sign_words_L00_QKVO_U1"]);
            var q = Pcg64.FromSeed(5);
            eq("integers_0_256_seed5", Json.Longs(q.Integers(0, 256, 12)), expect["integers_0_256_seed5"]);
            var z = Pcg64.FromText("0:emb");
            var nb = new List<object>();
            for (int i = 0; i < 6; i++) nb.Add(BitConverter.DoubleToInt64Bits(z.StandardNormal()).ToString("x16", U.Inv));
            eq("normal_bits_0_emb", nb, expect["normal_bits_0_emb"]);
            var logs = new List<object>();
            foreach (object o in expect.Arr("log1p_args")) logs.Add(BitConverter.DoubleToInt64Bits(FdLibm.Log1p(Json.ToDouble(o))).ToString("x16", U.Inv));
            eq("fdlibm_log1p_bits", logs, expect["fdlibm_log1p_bits"]);
            var reprs = new List<object>();
            foreach (object o in expect.Arr("repr_args")) reprs.Add(U.PyRepr(Json.ToDouble(o)));
            eq("python_repr", reprs, expect["python_repr"]);
            eq("sha512_abc", U.Sha512Text("abc"), expect["sha512_abc"]);
            var m1 = Model.Init(Gen.Model1Config(), 0);
            using (var hs = U.NewSha512())
            {
                foreach (string k in m1.Names) { var t = m1[k]; var bb = new byte[4 * t.Length]; Buffer.BlockCopy(t, 0, bb, 0, bb.Length); hs.TransformBlock(bb, 0, bb.Length, null, 0); }
                hs.TransformFinalBlock(new byte[0], 0, 0);
                eq("model1_seed0_init_sha512", U.Hex(hs.Hash), expect["model1_seed0_init_sha512"]);
            }
            eq("json_dump", Json.Dump(Json.Parse(expect.Str("json_in")), 1, true), expect["json_dump"]);
            eq("json_canonical", Json.Canonical(Json.Parse(expect.Str("json_in"))), expect["json_canonical"]);
            r["all_pass"] = all;
            return r;
        }
    }

    // ======== 11_rails.cs ========
    /// <summary>
    /// A byte unigram witness built from the training text: Laplace's rule of succession (MacKay (3.16)) generalised to
    /// K = 256 symbols with pseudo-count alpha, p(b) = (n_b + alpha) / (N + 256 alpha). It is a positive control for the
    /// reasoning layer's witness gate, not a language model: it ignores the prompt.
    /// </summary>
    public sealed class UnigramWitness
    {
        public readonly double[] LogP = new double[256];
        public readonly long[] Counts = new long[256];
        public long N;
        public double Alpha;
        public string DataSha512;

        public static double Smoothed(long count, long total, int k, double alpha) { return (count + alpha) / (total + k * alpha); }

        public static UnigramWitness FromBytes(byte[] data, double alpha, string sha)
        {
            if (!(alpha > 0) || !U.IsFinite(alpha)) throw new EngineError("unigram witness: alpha must be positive");
            var w = new UnigramWitness { N = data.LongLength, Alpha = alpha, DataSha512 = sha };
            foreach (byte b in data) w.Counts[b]++;
            for (int i = 0; i < 256; i++) w.LogP[i] = Math.Log(Smoothed(w.Counts[i], w.N, 256, alpha));
            return w;
        }
    }

    /// <summary>
    /// The integer arithmetic coder of rails_codelen (Witten, Neal and Cleary, 32-bit; MacKay chapter 6). Each step's
    /// probabilities are quantised to integer frequencies f = 1 + floor(p (65536 - V)), so every symbol stays codable;
    /// the coded length is at most the quantised ideal length plus 2 bits.
    /// </summary>
    public static class ArithCoder
    {
        const ulong TOP = 0xFFFFFFFFUL, HALF = 0x80000000UL, Q1 = 0x40000000UL, Q3 = 0xC0000000UL;
        public const int TOTAL = 1 << 16;

        public static int[] Freqs(double[] p)
        {
            int V = p.Length;
            if (V < 2 || V > 4096) throw new EngineError("arithmetic coder: 2 to 4096 symbols");
            var f = new int[V];
            for (int i = 0; i < V; i++)
            {
                double x = Math.Floor(p[i] * (TOTAL - V));
                if (!(x >= 0)) x = 0;
                if (x > TOTAL - V) x = TOTAL - V;
                f[i] = 1 + (int)x;
            }
            return f;
        }

        public static double QuantisedBits(double[] p, int sym)
        {
            var f = Freqs(p);
            long tot = 0;
            foreach (int x in f) tot += x;
            return -Math.Log((double)f[sym] / tot) / Math.Log(2.0);
        }

        public static List<byte> Encode(byte[] sym, double[][] P)
        {
            ulong low = 0, high = TOP;
            long pending = 0;
            var outp = new List<byte>();
            Action<byte> bit = b =>
            {
                outp.Add(b);
                for (long i = 0; i < pending; i++) outp.Add((byte)(1 - b));
                pending = 0;
            };
            for (int t = 0; t < sym.Length; t++)
            {
                var f = Freqs(P[t]);
                if (sym[t] >= f.Length) throw new EngineError("arithmetic coder: symbol outside the alphabet");
                ulong tot = 0, lo = 0;
                for (int j = 0; j < f.Length; j++) { if (j == sym[t]) lo = tot; tot += (ulong)f[j]; }
                ulong hi = lo + (ulong)f[sym[t]];
                ulong range = high - low + 1;
                high = low + range * hi / tot - 1;
                low = low + range * lo / tot;
                while (true)
                {
                    if (high < HALF) bit(0);
                    else if (low >= HALF) { bit(1); low -= HALF; high -= HALF; }
                    else if (low >= Q1 && high < Q3) { pending++; low -= Q1; high -= Q1; }
                    else break;
                    low = 2 * low;
                    high = 2 * high + 1;
                }
            }
            pending++;
            bit(low < Q1 ? (byte)0 : (byte)1);
            return outp;
        }

        /// <summary>Decodes n symbols; dist(decoded so far) gives the next step's probabilities, recomputed by the caller.</summary>
        public static byte[] Decode(List<byte> bits, int n, Func<List<byte>, double[]> dist)
        {
            int pos = 0;
            Func<ulong> nb = () => { ulong b = pos < bits.Count ? (ulong)bits[pos] : 0UL; pos++; return b; };
            ulong value = 0;
            for (int i = 0; i < 32; i++) value = 2 * value + nb();
            ulong low = 0, high = TOP;
            var outs = new List<byte>();
            for (int t = 0; t < n; t++)
            {
                var f = Freqs(dist(outs));
                ulong tot = 0;
                foreach (int x in f) tot += (ulong)x;
                if (value < low || value > high) throw new EngineError("arithmetic decoder: the stream left its interval");
                ulong range = high - low + 1;
                ulong scaled = ((value - low + 1) * tot - 1) / range;
                ulong cum = 0;
                int s = 0;
                while (s < f.Length && cum + (ulong)f[s] <= scaled) { cum += (ulong)f[s]; s++; }
                if (s >= f.Length) throw new EngineError("arithmetic decoder: corrupt stream");
                ulong hi = cum + (ulong)f[s];
                high = low + range * hi / tot - 1;
                low = low + range * cum / tot;
                while (true)
                {
                    if (high < HALF) { }
                    else if (low >= HALF) { low -= HALF; high -= HALF; value -= HALF; }
                    else if (low >= Q1 && high < Q3) { low -= Q1; high -= Q1; value -= Q1; }
                    else break;
                    low = 2 * low;
                    high = 2 * high + 1;
                    value = 2 * value + nb();
                }
                outs.Add((byte)s);
            }
            return outs.ToArray();
        }
    }

    /// <summary>
    /// RAILS-8S/1: the four-rail reasoning layer over the models' outputs (REASONING-RAILS-8S.cmd). Every operation returns
    /// one report with four rails, as in the Corpus Compendium on Rails: rail I the statement, rail II the log-linear form
    /// with its status, rail III the 8S admission (independence gate and gain gate), rail IV the robustness checks; and the
    /// retraction (all gates off), which holds by construction and is never counted as evidence.
    /// </summary>
    public static class Rails
    {
        public const string FRAMEWORK = "RAILS-8S/1";
        public const string ST_EXACT = "exact linear", ST_F2 = "exact linear over F2", ST_LOGS = "exact in logs",
            ST_LIN = "linearised", ST_STRUCT = "structural analogue", ST_NONE = "no faithful linear form";
        static readonly double LN2 = Math.Log(2.0);

        static EngineError Refuse(string op, string msg) { return new EngineError(op + ": " + msg); }

        // ---------------- numbers ----------------
        public static double LogSumExp(double[] a)
        {
            double m = double.NegativeInfinity;
            foreach (double x in a) if (x > m) m = x;
            if (double.IsNegativeInfinity(m)) return m;
            double s = 0;
            foreach (double x in a) s += Math.Exp(x - m);
            return m + Math.Log(s);
        }

        public static double[] NormalizeLog(double[] a, out double logZ)
        {
            logZ = LogSumExp(a);
            var r = new double[a.Length];
            for (int i = 0; i < a.Length; i++) r[i] = a[i] - logZ;
            return r;
        }

        public static double[] Exp(double[] a) { return a.Select(x => Math.Exp(x)).ToArray(); }

        public static double EntropyBits(double[] p)
        {
            double h = 0;
            foreach (double x in p) if (x > 0) h -= x * Math.Log(x);
            return h / LN2;
        }

        public static double KlBits(double[] p, double[] q)
        {
            double s = 0;
            for (int i = 0; i < p.Length; i++) if (p[i] > 0) s += p[i] * (Math.Log(p[i]) - Math.Log(q[i]));
            return s / LN2;
        }

        public static double Sigmoid(double x) { return x >= 0 ? 1.0 / (1.0 + Math.Exp(-x)) : Math.Exp(x) / (1.0 + Math.Exp(x)); }
        public static double Logit(double p) { return Math.Log(p) - Math.Log(1 - p); }

        static object Num(double x) { return U.IsFinite(x) ? (object)x : null; }
        static List<object> Nums(IEnumerable<double> v) { var l = new List<object>(); foreach (double x in v) l.Add(Num(x)); return l; }
        static List<object> Strs(IEnumerable<string> v) { var l = new List<object>(); foreach (string x in v) l.Add(x); return l; }

        static JObj Named(string[] names, double[] v)
        {
            var o = new JObj();
            for (int i = 0; i < names.Length; i++) o[names[i]] = Num(v[i]);
            return o;
        }

        // ---------------- spec reading ----------------
        public static JObj ReadSpec(string path)
        {
            byte[] raw = File.ReadAllBytes(path);
            var info = Doc.Inspect(raw);
            string text;
            if (info.Ok) text = U.Utf8.GetString(info.Payload);
            else if (info.Error == "no LB-DOC/1 marker line") text = U.Utf8.GetString(raw);
            else throw new EngineError(Path.GetFileName(path) + ": " + info.Error);
            if (text.Length > 0 && text[0] == (char)0xFEFF) text = text.Substring(1);
            return SpecOf(text, "spec");
        }

        public static JObj SpecOf(string text, string op)
        {
            object o;
            try { o = Json.Parse(text); }
            catch (EngineError e) { throw Refuse(op, "the spec is not JSON: " + e.Message); }
            catch (FormatException e) { throw Refuse(op, "the spec is not JSON: " + e.Message); }
            var j = o as JObj;
            if (j == null) throw Refuse(op, "the spec must be a JSON object");
            return j;
        }

        static double[] Doubles(object v, string what, string op)
        {
            var l = v as List<object>;
            if (l == null) throw Refuse(op, what + " must be a list of numbers");
            var r = new double[l.Count];
            for (int i = 0; i < l.Count; i++)
            {
                if (!Json.IsNumber(l[i])) throw Refuse(op, what + " must be a list of numbers");
                r[i] = Json.ToDouble(l[i]);
                if (!U.IsFinite(r[i])) throw Refuse(op, what + " holds a value that is not finite");
            }
            return r;
        }

        static string[] Strings(object v, string what, string op)
        {
            var l = v as List<object>;
            if (l == null) throw Refuse(op, what + " must be a list of strings");
            var r = new string[l.Count];
            for (int i = 0; i < l.Count; i++)
            {
                r[i] = l[i] as string;
                if (r[i] == null) throw Refuse(op, what + " must be a list of strings");
            }
            return r;
        }

        static double OptD(JObj spec, string key, double dflt, string op)
        {
            object v = spec.Get(key);
            if (v == null) return dflt;
            if (!Json.IsNumber(v)) throw Refuse(op, key + " must be a number");
            double x = Json.ToDouble(v);
            if (!U.IsFinite(x)) throw Refuse(op, key + " must be finite");
            return x;
        }

        static double[] LogPrior(JObj spec, int K, string op)
        {
            if (spec.Get("prior") != null)
            {
                var p = Doubles(spec.Get("prior"), "prior", op);
                if (p.Length != K) throw Refuse(op, "prior needs one value per hypothesis");
                double s = 0;
                foreach (double x in p) { if (x < 0) throw Refuse(op, "prior values must not be negative"); s += x; }
                if (Math.Abs(s - 1) > 1e-9) throw Refuse(op, "the prior must sum to 1 (it sums to " + U.PyRepr(s) + ")");
                return p.Select(x => Math.Log(x)).ToArray();
            }
            var u = new double[K];
            for (int i = 0; i < K; i++) u[i] = -Math.Log(K);
            return u;
        }

        static double Lambda(JObj spec, string op)
        {
            double lambda = OptD(spec, "lambda", 1.0, op);
            if (!(lambda > 0)) throw Refuse(op, "lambda must be positive");
            return lambda;
        }

        // ---------------- the 8S independence gate (Theorem A: a rank-increment test) ----------------
        /// <summary>eta = ||(I - C C+) e||^2 / (||e||^2 + eps) against the admitted codes C.</summary>
        public sealed class Gate
        {
            readonly List<double[]> basis = new List<double[]>();
            public const double Eps = 1e-12;
            public int Rank { get { return basis.Count; } }

            double[] Residual(double[] e)
            {
                var r = (double[])e.Clone();
                for (int pass = 0; pass < 2; pass++)
                    foreach (var q in basis)
                    {
                        double d = 0;
                        for (int i = 0; i < r.Length; i++) d += q[i] * r[i];
                        for (int i = 0; i < r.Length; i++) r[i] -= d * q[i];
                    }
                return r;
            }

            public double Eta(double[] e)
            {
                double ee = 0;
                foreach (double x in e) ee += x * x;
                double rr = 0;
                foreach (double x in Residual(e)) rr += x * x;
                return rr / (ee + Eps);
            }

            public void Admit(double[] e)
            {
                var r = Residual(e);
                double n = 0;
                foreach (double x in r) n += x * x;
                n = Math.Sqrt(n);
                if (!(n > 1e-150)) return;
                for (int i = 0; i < r.Length; i++) r[i] /= n;
                basis.Add(r);
            }
        }

        // ---------------- decision theory with abstention (MacKay chapter 36) ----------------
        sealed class Decision
        {
            public int Top, Second;
            public bool Answer;
            public string Reason;
            public double Tau, PTop, Margin, ThresholdMargin;
        }

        /// <summary>Utility +1 for a right answer, -lambda for a wrong one, 0 for abstaining: answer h* iff P(h*) > lambda / (1 + lambda).</summary>
        static Decision Decide(double[] logPost, double lambda)
        {
            var d = new Decision { Tau = lambda / (1 + lambda) };
            int K = logPost.Length, top = 0;
            for (int i = 1; i < K; i++) if (logPost[i] > logPost[top]) top = i;
            int sec = top == 0 ? 1 : 0;
            for (int i = 0; i < K; i++) if (i != top && logPost[i] > logPost[sec]) sec = i;
            d.Top = top;
            d.Second = sec;
            d.PTop = Math.Exp(logPost[top]);
            d.Margin = logPost[top] - logPost[sec];
            bool tie = !(d.Margin > 0);
            d.ThresholdMargin = Logit(d.PTop) - Logit(d.Tau);
            d.Answer = !tie && d.PTop > d.Tau;
            d.Reason = tie ? "the two most probable hypotheses are tied" : d.Answer ? "the posterior of the best hypothesis is above lambda/(1+lambda)"
                : "the posterior of the best hypothesis is not above lambda/(1+lambda)";
            return d;
        }

        static JObj DecisionRail(Decision d, double lambda)
        {
            return new JObj().Set("status", ST_STRUCT).Set("rule", "answer the most probable hypothesis only if its posterior exceeds lambda/(1+lambda); otherwise abstain")
                .Set("lambda", lambda).Set("threshold", d.Tau).Set("posterior_max", Num(d.PTop))
                .Set("margin_log_odds", Num(d.Margin)).Set("flip_factor", Num(Math.Exp(d.Margin)))
                .Set("threshold_margin_log_odds", Num(d.ThresholdMargin)).Set("reason", d.Reason);
        }

        static JObj Retraction(JObj gatesOff, string note)
        {
            return new JObj().Set("gates_off", gatesOff).Set("by_construction", true).Set("counts_as_evidence", false).Set("note", note);
        }

        static JObj Head(string op, string statement, string decision, object answer)
        {
            return new JObj().Set("framework", FRAMEWORK).Set("op", op).Set("statement", statement).Set("decision", decision).Set("answer", answer);
        }

        static double[] LogLik(JObj e, int K, string op, string name)
        {
            if (e.Get("likelihood") != null)
            {
                var l = Doubles(e.Get("likelihood"), name + ": likelihood", op);
                if (l.Length != K) throw Refuse(op, name + ": one likelihood per hypothesis is needed");
                bool any = false;
                foreach (double x in l) { if (x < 0) throw Refuse(op, name + ": likelihoods must not be negative"); if (x > 0) any = true; }
                if (!any) throw Refuse(op, name + ": the evidence has likelihood 0 under every hypothesis");
                return l.Select(x => Math.Log(x)).ToArray();
            }
            if (e.Get("log_likelihood") != null)
            {
                var l = Doubles(e.Get("log_likelihood"), name + ": log_likelihood", op);
                if (l.Length != K) throw Refuse(op, name + ": one log likelihood per hypothesis is needed");
                return l;
            }
            throw Refuse(op, name + ": give likelihood or log_likelihood");
        }

        // ---------------- rails_bayes ----------------
        /// <summary>Bayes' theorem with provenance-gated evidence (MacKay (2.10), (1.18)-(1.23)), then a decision with abstention.</summary>
        public static JObj Bayes(JObj spec)
        {
            const string op = "rails_bayes";
            var hyp = Strings(spec.Get("hypotheses"), "hypotheses", op);
            int K = hyp.Length;
            if (K < 2) throw Refuse(op, "at least two hypotheses are needed");
            if (new HashSet<string>(hyp, StringComparer.Ordinal).Count != K) throw Refuse(op, "hypothesis names must be distinct");
            double epsInd = OptD(spec, "eps_ind", 0.5, op), epsGain = OptD(spec, "eps_gain_bits", 0.0, op), lambda = Lambda(spec, op);
            var logPrior = LogPrior(spec, K, op);
            var evidence = spec.Get("evidence") as List<object> ?? new List<object>();
            var items = new List<JObj>();
            var tagIndex = new Dictionary<string, int>(StringComparer.Ordinal);
            foreach (object o in evidence)
            {
                var e = o as JObj;
                if (e == null) throw Refuse(op, "each evidence item must be an object");
                items.Add(e);
                foreach (string t in Strings(e.Get("tags"), "tags", op)) if (!tagIndex.ContainsKey(t)) tagIndex[t] = tagIndex.Count;
            }
            var gate = new Gate();
            var cur = (double[])logPrior.Clone();
            var all = (double[])logPrior.Clone();
            double logEv = 0;
            var recs = new List<object>();
            var admitted = new List<object>();
            var rejected = new List<object>();
            int idx = 0;
            foreach (var e in items)
            {
                idx++;
                string name = e.Get("name") as string ?? ("evidence " + idx.ToString(U.Inv));
                var tags = Strings(e.Get("tags"), "tags", op);
                if (tags.Length == 0) throw Refuse(op, name + ": tags (the evidence's provenance) are required");
                var ll = LogLik(e, K, op, name);
                var code = new double[tagIndex.Count];
                foreach (string t in tags) code[tagIndex[t]] = 1.0;
                double eta = gate.Eta(code);
                var joint = new double[K];
                for (int k = 0; k < K; k++) joint[k] = cur[k] + ll[k];
                double z;
                var next = NormalizeLog(joint, out z);
                if (double.IsNegativeInfinity(z) || double.IsNaN(z)) throw Refuse(op, name + ": the evidence is impossible under every hypothesis still possible");
                double gain = KlBits(Exp(next), Exp(cur));
                bool ok = eta >= epsInd && gain > epsGain;
                string reason = ok ? "admitted" : eta < epsInd ? "not independent: its provenance lies in the span of admitted evidence" : "no information gain";
                if (ok) { gate.Admit(code); cur = next; logEv += z; admitted.Add(name); }
                else rejected.Add(name);
                for (int k = 0; k < K; k++) all[k] += ll[k];
                recs.Add(new JObj().Set("name", name).Set("tags", Strs(tags)).Set("eta_ind", eta).Set("gain_bits", gain).Set("admitted", ok)
                    .Set("reason", reason).Set("log_evidence_nats", Num(z)));
            }
            double zOff;
            var off = NormalizeLog(all, out zOff);
            bool offDefined = U.IsFinite(zOff);
            var post = Exp(cur);
            var d = Decide(cur, lambda);
            string answer = d.Answer ? hyp[d.Top] : null;
            var rep = Head(op, d.Answer ? "the most probable hypothesis is " + hyp[d.Top] + ", with posterior " + U.PyRepr(d.PTop) : "abstain: " + d.Reason,
                d.Answer ? "answer" : "abstain", answer);
            rep["posterior"] = Named(hyp, post);
            rep["admitted"] = admitted;
            rep["rejected"] = rejected;
            rep["rail_I"] = new JObj().Set("question", spec.Get("question")).Set("hypotheses", Strs(hyp)).Set("evidence_items", (long)items.Count);
            rep["rail_II"] = new JObj().Set("status", ST_LOGS).Set("rule", "log posterior = log prior + sum of the admitted log likelihoods - log Z")
                .Set("log_prior", Nums(logPrior)).Set("log_posterior", Nums(cur)).Set("log_evidence_nats", Num(logEv))
                .Set("entropy_prior_bits", EntropyBits(Exp(logPrior))).Set("entropy_posterior_bits", EntropyBits(post));
            rep["rail_III"] = new JObj().Set("rule", "admit evidence e iff eta_ind(e) >= eps_ind and gain_bits(e) > eps_gain_bits; eta_ind is computed on the provenance tags; gain_bits = KL(posterior with e || posterior without e)")
                .Set("eps_ind", epsInd).Set("eps_gain_bits", epsGain).Set("rank", (long)gate.Rank).Set("items", recs);
            rep["rail_IV"] = DecisionRail(d, lambda);
            JObj offRep = new JObj().Set("posterior", offDefined ? (object)Named(hyp, Exp(off)) : null);
            if (offDefined)
            {
                var dOff = Decide(off, lambda);
                offRep["answer"] = dOff.Answer ? hyp[dOff.Top] : null;
            }
            rep["retraction"] = Retraction(offRep, "every item admitted, whatever its provenance or gain: the plain product of all likelihoods");
            return rep;
        }

        // ---------------- rails_admit ----------------
        /// <summary>The 8S admission law for reasoning steps: Admit iff eta_ind >= eps_ind and the step's gain > eps_gain.</summary>
        public static JObj Admit(JObj spec)
        {
            const string op = "rails_admit";
            var itemsL = spec.Get("items") as List<object>;
            if (itemsL == null || itemsL.Count == 0) throw Refuse(op, "items must be a non-empty list");
            double epsInd = OptD(spec, "eps_ind", 0.01, op), epsGain = OptD(spec, "eps_gain_bits", 0.0, op);
            var items = new List<JObj>();
            var tagIndex = new Dictionary<string, int>(StringComparer.Ordinal);
            int dim = -1;
            bool anyTags = false, anyCode = false;
            foreach (object o in itemsL)
            {
                var e = o as JObj;
                if (e == null) throw Refuse(op, "each item must be an object");
                items.Add(e);
                if (e.Get("tags") != null)
                {
                    anyTags = true;
                    foreach (string t in Strings(e.Get("tags"), "tags", op)) if (!tagIndex.ContainsKey(t)) tagIndex[t] = tagIndex.Count;
                }
                else if (e.Get("code") != null)
                {
                    anyCode = true;
                    int n = Doubles(e.Get("code"), "code", op).Length;
                    if (dim >= 0 && n != dim) throw Refuse(op, "every code must have the same length");
                    dim = n;
                }
                else throw Refuse(op, "each item needs a code (numbers) or tags");
            }
            if (anyTags && anyCode) throw Refuse(op, "use either tags or numeric codes for every item, not both");
            if (anyTags) dim = tagIndex.Count;
            var gate = new Gate();
            var gateAll = new Gate();
            var recs = new List<object>();
            var admitted = new List<object>();
            var rejected = new List<object>();
            double total = 0, totalAll = 0;
            int idx = 0;
            foreach (var e in items)
            {
                idx++;
                string name = e.Get("name") as string ?? ("item " + idx.ToString(U.Inv));
                double gain = OptD(e, "gain_bits", double.NaN, op);
                if (double.IsNaN(gain)) throw Refuse(op, name + ": gain_bits is required");
                double[] code;
                if (anyTags)
                {
                    code = new double[dim];
                    foreach (string t in Strings(e.Get("tags"), "tags", op)) code[tagIndex[t]] = 1.0;
                }
                else code = Doubles(e.Get("code"), "code", op);
                double eta = gate.Eta(code);
                bool ok = eta >= epsInd && gain > epsGain;
                string reason = ok ? "admitted" : eta < epsInd ? "not independent: in the span of the admitted codes" : "no gain";
                if (ok) { gate.Admit(code); total += gain; admitted.Add(name); }
                else rejected.Add(name);
                gateAll.Admit(code);
                totalAll += gain;
                recs.Add(new JObj().Set("name", name).Set("eta_ind", eta).Set("gain_bits", gain).Set("admitted", ok).Set("reason", reason));
            }
            var rep = Head(op, "admitted " + admitted.Count.ToString(U.Inv) + " of " + items.Count.ToString(U.Inv) + " steps; rank " + gate.Rank.ToString(U.Inv),
                "admit", null);
            rep["admitted"] = admitted;
            rep["rejected"] = rejected;
            rep["rank"] = (long)gate.Rank;
            rep["total_gain_bits"] = total;
            rep["rail_I"] = new JObj().Set("steps", (long)items.Count).Set("code_dimension", (long)dim).Set("codes", anyTags ? "tags (one-hot)" : "numbers");
            rep["rail_II"] = new JObj().Set("status", ST_EXACT).Set("rule", "eta_ind = ||(I - C C+) e||^2 / (||e||^2 + 1e-12): the residual of e after projection on the span C of the admitted codes");
            rep["rail_III"] = new JObj().Set("rule", "Admit(8S) iff eta_ind >= eps_ind and gain_bits > eps_gain_bits; rank(C) grows by one per admitted step (Theorem A)")
                .Set("eps_ind", epsInd).Set("eps_gain_bits", epsGain).Set("items", recs);
            rep["rail_IV"] = new JObj().Set("redundant_steps_rejected", (long)recs.Count(o => !(bool)((JObj)o)["admitted"] && (double)((JObj)o)["eta_ind"] < epsInd));
            rep["retraction"] = Retraction(new JObj().Set("rank", (long)gateAll.Rank).Set("total_gain_bits", totalAll),
                "every step admitted: the gains of redundant steps are counted again");
            return rep;
        }

        // ---------------- rails_meanfield ----------------
        /// <summary>The 8S gate layer p = sigma(h + J(2p - 1)) for coupled claims (MacKay chapters 31 and 33), only under the
        /// contraction certificate kappa = max_i sum_j |J_ij| / 2 &lt; 1 (Theorem H), and checked against exact enumeration.</summary>
        public static JObj MeanField(JObj spec)
        {
            const string op = "rails_meanfield";
            var names = Strings(spec.Get("claims"), "claims", op);
            int n = names.Length;
            if (n < 1 || n > 16) throw Refuse(op, "1 to 16 claims are supported (the exact check enumerates 2^n states)");
            var h = Doubles(spec.Get("h"), "h", op);
            if (h.Length != n) throw Refuse(op, "h needs one field per claim");
            var Jl = spec.Get("J") as List<object>;
            if (Jl == null || Jl.Count != n) throw Refuse(op, "J must be an n x n matrix");
            var J = new double[n, n];
            for (int i = 0; i < n; i++)
            {
                var row = Doubles(Jl[i], "J row", op);
                if (row.Length != n) throw Refuse(op, "J must be an n x n matrix");
                for (int j = 0; j < n; j++) J[i, j] = row[j];
            }
            for (int i = 0; i < n; i++)
            {
                if (J[i, i] != 0) throw Refuse(op, "J must have a zero diagonal");
                for (int j = 0; j < n; j++) if (Math.Abs(J[i, j] - J[j, i]) > 1e-12) throw Refuse(op, "J must be symmetric: an asymmetric coupling has no energy (no faithful form)");
            }
            long maxIt = (long)OptD(spec, "max_iters", 10000, op);
            double tol = OptD(spec, "tol", 1e-12, op), lambda = Lambda(spec, op);
            if (maxIt < 1 || !(tol > 0)) throw Refuse(op, "max_iters must be at least 1 and tol positive");
            double kappa = 0;
            for (int i = 0; i < n; i++)
            {
                double s = 0;
                for (int j = 0; j < n; j++) s += Math.Abs(J[i, j]);
                kappa = Math.Max(kappa, 0.5 * s);
            }
            if (!(kappa < 1))
                throw Refuse(op, "no contraction certificate: kappa = " + U.PyRepr(kappa) + " >= 1, so the gate may have several fixed points and its answer is not unique");
            var p = new double[n];
            for (int i = 0; i < n; i++) p[i] = Sigmoid(h[i]);
            long it = 0;
            double delta = double.PositiveInfinity;
            while (it < maxIt)
            {
                var q = new double[n];
                delta = 0;
                for (int i = 0; i < n; i++)
                {
                    double x = h[i];
                    for (int j = 0; j < n; j++) x += J[i, j] * (2 * p[j] - 1);
                    q[i] = Sigmoid(x);
                    delta = Math.Max(delta, Math.Abs(q[i] - p[i]));
                }
                p = q;
                it++;
                if (delta < tol) break;
            }
            if (!(delta < tol)) throw Refuse(op, "the mean-field iteration did not reach tol within max_iters");
            int S = 1 << n;
            var lw = new double[S];
            double mx = double.NegativeInfinity;
            for (int s = 0; s < S; s++)
            {
                double e = 0;
                for (int i = 0; i < n; i++)
                {
                    double si = ((s >> i) & 1) == 1 ? 1.0 : -1.0;
                    e += 0.5 * h[i] * si;
                    for (int j = i + 1; j < n; j++) e += 0.5 * J[i, j] * si * (((s >> j) & 1) == 1 ? 1.0 : -1.0);
                }
                lw[s] = e;
                if (e > mx) mx = e;
            }
            double Z = 0;
            var m = new double[n];
            for (int s = 0; s < S; s++)
            {
                double w = Math.Exp(lw[s] - mx);
                Z += w;
                for (int i = 0; i < n; i++) if (((s >> i) & 1) == 1) m[i] += w;
            }
            var exact = m.Select(x => x / Z).ToArray();
            double err = 0;
            for (int i = 0; i < n; i++) err = Math.Max(err, Math.Abs(p[i] - exact[i]));
            double tau = lambda / (1 + lambda);
            Func<double, string> verdict = x => x > tau ? "accept" : x < 1 - tau ? "reject" : "undecided";
            var decE = new JObj();
            var decM = new JObj();
            bool agree = true;
            for (int i = 0; i < n; i++)
            {
                decE[names[i]] = verdict(exact[i]);
                decM[names[i]] = verdict(p[i]);
                if (verdict(exact[i]) != verdict(p[i])) agree = false;
            }
            var rep = Head(op, "coupled claims decided from their exact marginals; the mean-field gate agrees " + (agree ? "on every claim" : "on some claims only"),
                "decide", null);
            rep["decisions"] = decE;
            rep["marginals"] = Named(names, exact);
            rep["kappa"] = kappa;
            rep["certified"] = true;
            rep["rail_I"] = new JObj().Set("claims", Strs(names)).Set("model", "P(s) proportional to exp(sum_i h_i s_i / 2 + sum_{i<j} J_ij s_i s_j / 2), s_i = +1 when claim i holds");
            rep["rail_II"] = new JObj().Set("status", ST_LOGS).Set("method", "complete enumeration of the 2^n states (MacKay chapter 21)").Set("marginals", Named(names, exact))
                .Set("log_partition", mx + Math.Log(Z));
            rep["rail_III"] = new JObj().Set("rule", "mean-field gate p = sigma(h + J(2p - 1)) (8S gate layer); unique fixed point if kappa = max_i sum_j |J_ij| / 2 < 1 (Theorem H)")
                .Set("status", ST_LIN).Set("kappa", kappa).Set("certified", true).Set("iterations", it).Set("last_change", delta).Set("meanfield", Named(names, p))
                .Set("decisions", decM);
            rep["rail_IV"] = new JObj().Set("max_abs_error_meanfield_vs_exact", err).Set("decisions_agree", agree).Set("lambda", lambda).Set("threshold", tau)
                .Set("rule", "accept a claim if its marginal exceeds lambda/(1+lambda), reject it if the marginal is below 1 - lambda/(1+lambda), otherwise undecided");
            rep["retraction"] = Retraction(new JObj().Set("marginals", Named(names, h.Select(x => Sigmoid(x)).ToArray())), "couplings switched off (J = 0): every claim on its own field");
            return rep;
        }

        // ---------------- rails_parity ----------------
        static double Median(double a, double b, double c) { return Math.Max(Math.Min(a, b), Math.Min(Math.Max(a, b), c)); }

        /// <summary>Three routes to one number as a repetition code R3 (MacKay (1.18)-(1.23), (1.51)-(1.52)): pairwise checks,
        /// majority decoding of a single deviating route, refusal otherwise.</summary>
        public static JObj Parity(JObj spec, double a, double b, double c)
        {
            const string op = "rails_parity";
            var routes = Strings(spec.Get("routes"), "routes", op);
            if (routes.Length != 3) throw Refuse(op, "three routes are needed (a repetition code R3)");
            double tol = OptD(spec, "tolerance", -1, op);
            if (!(tol > 0)) throw Refuse(op, "tolerance must be positive");
            bool rel = spec.Get("relative") is bool && (bool)spec.Get("relative");
            if (!U.IsFinite(a) || !U.IsFinite(b) || !U.IsFinite(c)) throw Refuse(op, "a route returned a value that is not finite");
            Func<double, double, bool> dis = (x, y) => Math.Abs(x - y) > (rel ? tol * Math.Max(Math.Max(Math.Abs(x), Math.Abs(y)), 1e-300) : tol);
            bool sab = dis(a, b), sbc = dis(b, c), sac = dis(a, c);
            string syn = (sab ? "1" : "0") + (sbc ? "1" : "0") + (sac ? "1" : "0");
            int outlier;
            if (!sab && !sbc && !sac) outlier = -1;
            else if (sab && sac && !sbc) outlier = 0;
            else if (sab && sbc && !sac) outlier = 1;
            else if (sbc && sac && !sab) outlier = 2;
            else throw Refuse(op, "no majority among the three routes (pairwise checks ab, bc, ac = " + syn + ")");
            double value = Median(a, b, c);
            var vals = new JObj().Set(routes[0], a).Set(routes[1], b).Set(routes[2], c);
            var rep = Head(op, outlier < 0 ? "the three routes agree" : "route '" + routes[outlier] + "' disagrees with the other two and is outvoted", "decode", null);
            rep["syndrome"] = syn;
            rep["corrected"] = outlier >= 0;
            rep["outlier"] = outlier >= 0 ? (object)routes[outlier] : null;
            rep["value"] = value;
            rep["rail_I"] = new JObj().Set("routes", vals);
            rep["rail_II"] = new JObj().Set("status", ST_F2).Set("rule", "check bits z_ab = [|a - b| > tol], z_bc, z_ac; (z_ab, z_bc) is the syndrome of R3 and z_ac the redundant check, which must equal z_ab xor z_bc")
                .Set("tolerance", tol).Set("relative", rel).Set("checks", new JObj().Set("ab", sab).Set("bc", sbc).Set("ac", sac));
            rep["rail_III"] = new JObj().Set("rule", "majority decoding: one deviating route is outvoted; two or more, or an inconsistent syndrome, and the value is refused").Set("decoded_value", value);
            rep["rail_IV"] = new JObj().Set("status", ST_STRUCT).Set("spread", Math.Max(a, Math.Max(b, c)) - Math.Min(a, Math.Min(b, c)));
            rep["retraction"] = Retraction(new JObj().Set("value", a), "checks switched off: the first route is taken as it is");
            return rep;
        }

        // ---------------- witnesses: a weight set or the unigram ----------------
        static long[] Tok(byte[] b) { var t = new long[b.Length]; for (int i = 0; i < b.Length; i++) t[i] = b[i]; return t; }

        static double LogSoftmaxAt(double[] logits, int row, int V, int sym)
        {
            int o = row * V;
            double m = double.NegativeInfinity;
            for (int j = 0; j < V; j++) if (logits[o + j] > m) m = logits[o + j];
            double z = 0;
            for (int j = 0; j < V; j++) z += Math.Exp(logits[o + j] - m);
            return logits[o + sym] - m - Math.Log(z);
        }

        static double[] SoftmaxRow(double[] logits, int row, int V)
        {
            int o = row * V;
            double m = double.NegativeInfinity;
            for (int j = 0; j < V; j++) if (logits[o + j] > m) m = logits[o + j];
            var p = new double[V];
            double z = 0;
            for (int j = 0; j < V; j++) { p[j] = Math.Exp(logits[o + j] - m); z += p[j]; }
            for (int j = 0; j < V; j++) p[j] /= z;
            return p;
        }

        static readonly Dictionary<string, string> TIER_NAMES = new Dictionary<string, string>(StringComparer.Ordinal) {
            { "exact", "EXACT-BF16" }, { "tier2", "TIER-2" }, { "tier1", "TIER-1" }, { "tier0", "TIER-0" } };

        /// <summary>The witness of a CLI spec: {"manifest": path, "tier": t, "pin": optional} or {"unigram": [shards], "data_sha512": optional, "alpha": a}.</summary>
        public static object LoadWitness(JObj w, string baseDir, out JObj about)
        {
            if (w == null) throw new EngineError("reason: the spec needs a witness object");
            Func<string, string> full = p => Path.GetFullPath(Path.Combine(baseDir, p.Replace('/', Path.DirectorySeparatorChar)));
            if (w.Get("manifest") != null)
            {
                string tier = w.Get("tier") as string ?? "exact";
                if (!TIER_NAMES.ContainsKey(tier)) throw new EngineError("reason: tier is exact, tier2, tier1 or tier0");
                string pin = w.Get("pin") as string;
                about = new JObj().Set("kind", "weights").Set("manifest", w.Str("manifest")).Set("tier", TIER_NAMES[tier]);
                return Loader.Load(full(w.Str("manifest")), TIER_NAMES[tier], pin);
            }
            if (w.Get("unigram") != null)
            {
                var shards = Strings(w.Get("unigram"), "unigram", "reason").Select(full).ToList();
                double alpha = OptD(w, "alpha", 1.0, "reason");
                byte[] data = Gen.DataUnpack(shards);
                string sha = U.Sha512Hex(data);
                string pin = w.Get("data_sha512") as string;
                if (pin != null && pin != sha) throw new EngineError("reason: the data's SHA-512 is not the pinned one");
                about = new JObj().Set("kind", "unigram").Set("alpha", alpha).Set("data_sha512", sha).Set("bytes", data.LongLength);
                return UnigramWitness.FromBytes(data, alpha, sha);
            }
            throw new EngineError("reason: the witness needs manifest or unigram");
        }

        /// <summary>The witness's code length of a text in bits, and its log likelihood of continuations of a prompt.</summary>
        static double CodeBits(object witness, byte[] x)
        {
            var w = witness as IWeights;
            if (w != null)
            {
                int V = w.Config.Vocab;
                var lg = Kernels.ForwardAll(Tok(x), w);
                double bits = 8.0;
                for (int t = 1; t < x.Length; t++) bits -= LogSoftmaxAt(lg, t - 1, V, x[t]) / LN2;
                return bits;
            }
            var u = (UnigramWitness)witness;
            double ub = 0;
            foreach (byte b in x) ub -= u.LogP[b] / LN2;
            return ub;
        }

        static double ContinuationLogLik(object witness, byte[] prompt, byte[] cand)
        {
            var w = witness as IWeights;
            if (w != null)
            {
                int V = w.Config.Vocab;
                var seq = new byte[prompt.Length + cand.Length];
                Buffer.BlockCopy(prompt, 0, seq, 0, prompt.Length);
                Buffer.BlockCopy(cand, 0, seq, prompt.Length, cand.Length);
                var lg = Kernels.ForwardAll(Tok(seq), w);
                double ll = 0;
                for (int t = prompt.Length; t < seq.Length; t++) ll += LogSoftmaxAt(lg, t - 1, V, seq[t]);
                return ll;
            }
            var u = (UnigramWitness)witness;
            double s = 0;
            foreach (byte b in cand) s += u.LogP[b];
            return s;
        }

        // ---------------- rails_witness ----------------
        /// <summary>A model as a witness for a multiple-choice question (MacKay chapters 21, 28): admitted only if it codes a
        /// calibration text in fewer bits than the uniform byte code; then Bayes over the candidates and a decision with abstention.</summary>
        public static JObj Witness(object witness, JObj about, JObj spec)
        {
            const string op = "rails_witness";
            string prompt = spec.Get("prompt") as string ?? "";
            var cands = Strings(spec.Get("candidates"), "candidates", op);
            int K = cands.Length;
            if (K < 2) throw Refuse(op, "at least two candidates are needed");
            if (new HashSet<string>(cands, StringComparer.Ordinal).Count != K) throw Refuse(op, "candidates must be distinct");
            if (cands.Any(x => x.Length == 0)) throw Refuse(op, "candidates must not be empty");
            string cal = spec.Get("calibration") as string ?? prompt;
            double epsGain = OptD(spec, "eps_gain_bits", 0.0, op), lambda = Lambda(spec, op);
            var logPrior = LogPrior(spec, K, op);
            byte[] pb = U.Utf8.GetBytes(prompt), cb = U.Utf8.GetBytes(cal);
            var cbs = cands.Select(x => U.Utf8.GetBytes(x)).ToArray();
            var w = witness as IWeights;
            if (w != null)
            {
                int seq = w.Config.SeqLen;
                if (pb.Length < 1) throw Refuse(op, "a model witness needs a prompt of at least one byte");
                if (cb.Length < 2 || cb.Length > seq) throw Refuse(op, "the calibration text needs 2 to seq_len bytes");
                foreach (var x in cbs) if (pb.Length + x.Length > seq) throw Refuse(op, "prompt plus candidate exceeds the model's context");
                foreach (var x in cbs) foreach (byte b in x) if (b >= w.Config.Vocab) throw Refuse(op, "a candidate byte is outside the vocabulary");
            }
            else if (!(witness is UnigramWitness)) throw Refuse(op, "the witness must be a weight set or a unigram witness");
            else if (cb.Length < 1) throw Refuse(op, "the calibration text is empty");
            double calBits = CodeBits(witness, cb), baseBits = 8.0 * cb.Length, gain = baseBits - calBits;
            bool admitted = gain > epsGain;
            var ll = new double[K];
            for (int k = 0; k < K; k++) ll[k] = ContinuationLogLik(witness, pb, cbs[k]);
            var withW = new double[K];
            for (int k = 0; k < K; k++) withW[k] = logPrior[k] + ll[k];
            double z1;
            var postW = NormalizeLog(withW, out z1);
            var cur = admitted ? postW : (double[])logPrior.Clone();
            var d = Decide(cur, lambda);
            bool equalLen = cbs.All(x => x.Length == cbs[0].Length);
            int topRaw = 0, topNorm = 0;
            for (int k = 1; k < K; k++)
            {
                if (ll[k] > ll[topRaw]) topRaw = k;
                if (ll[k] / cbs[k].Length > ll[topNorm] / cbs[topNorm].Length) topNorm = k;
            }
            bool normAgrees = topRaw == topNorm;
            bool answer = d.Answer && (equalLen || normAgrees || !admitted);
            string reason = !admitted ? "the witness was not admitted, so the decision rests on the prior alone; " + d.Reason
                : (!equalLen && !normAgrees) ? "the ranking changes under per-byte normalisation, so the answer is not robust" : d.Reason;
            var rep = Head(op, answer ? "the answer is '" + cands[d.Top] + "'" : "abstain: " + reason, answer ? "answer" : "abstain", answer ? (object)cands[d.Top] : null);
            rep["posterior"] = Named(cands, Exp(cur));
            rep["witness"] = about;
            rep["rail_I"] = new JObj().Set("prompt", prompt).Set("candidates", Strs(cands)).Set("calibration_bytes", (long)cb.Length);
            var llBits = ll.Select(x => -x / LN2).ToArray();
            rep["rail_II"] = new JObj().Set("status", ST_LOGS).Set("rule", "log P(candidate | prompt) = sum over its bytes of log p(byte | everything before it), teacher-forced (complete enumeration over the candidates)")
                .Set("candidate_log_likelihood_nats", Named(cands, ll)).Set("candidate_code_bits", Named(cands, llBits))
                .Set("calibration_bits", calBits).Set("calibration_bits_per_byte", calBits / cb.Length);
            rep["rail_III"] = new JObj().Set("rule", "admit the witness iff it codes the calibration text in fewer bits than the uniform byte code by more than eps_gain_bits (evidence ratio > 1, MacKay chapter 28)")
                .Set("baseline_bits", baseBits).Set("gain_bits", gain).Set("eps_gain_bits", epsGain).Set("admitted", admitted)
                .Set("reason", admitted ? "the witness predicts the calibration text better than chance" : "the witness predicts the calibration text no better than chance");
            var r4 = DecisionRail(d, lambda);
            r4["equal_lengths"] = equalLen;
            r4["length_normalised_ranking_agrees"] = normAgrees;
            r4["reason"] = reason;
            rep["rail_IV"] = r4;
            var dOff = Decide(postW, lambda);
            rep["retraction"] = Retraction(new JObj().Set("posterior", Named(cands, Exp(postW))).Set("answer", dOff.Answer ? (object)cands[dOff.Top] : null),
                "witness admitted whatever its gain: the posterior an ungated system would report");
            return rep;
        }

        // ---------------- rails_codelen ----------------
        /// <summary>The witness as a compressor (MacKay chapters 4-6): arithmetic coding of a text, decoding with probabilities
        /// recomputed from the decoded prefix, and the code length against the ideal sum of -log2 p.</summary>
        public static JObj CodeLen(object witness, JObj about, string text)
        {
            const string op = "rails_codelen";
            byte[] x = U.Utf8.GetBytes(text ?? "");
            int n = x.Length;
            var w = witness as IWeights;
            var uw = witness as UnigramWitness;
            var uniform = Enumerable.Repeat(1.0 / 256, 256).ToArray();
            var P = new double[n][];
            double[] full = null;
            double[] up = null;
            if (w != null)
            {
                if (w.Config.Vocab != 256) throw Refuse(op, "the arithmetic coder needs a byte-vocabulary witness (V = 256)");
                if (n < 2 || n > w.Config.SeqLen) throw Refuse(op, "the text needs 2 to seq_len bytes");
                full = Kernels.ForwardAll(Tok(x), w);
                P[0] = uniform;
                for (int t = 1; t < n; t++) P[t] = SoftmaxRow(full, t - 1, 256);
            }
            else if (uw != null)
            {
                if (n < 1) throw Refuse(op, "the text is empty");
                up = Exp(uw.LogP);
                for (int t = 0; t < n; t++) P[t] = up;
            }
            else throw Refuse(op, "the witness must be a weight set or a unigram witness");
            double ideal = 0, quant = 0, ce = 0;
            for (int t = 0; t < n; t++)
            {
                ideal -= Math.Log(P[t][x[t]]) / LN2;
                quant += ArithCoder.QuantisedBits(P[t], x[t]);
                if (t >= 1) ce -= Math.Log(P[t][x[t]]);
            }
            ce /= Math.Max(1, n - 1);
            var bits = ArithCoder.Encode(x, P);
            double maxDiff = 0;
            byte[] dec = null;
            string decErr = null;
            try
            {
                dec = ArithCoder.Decode(bits, n, prefix =>
                {
                    int t = prefix.Count;
                    if (uw != null) return up;
                    if (t == 0) return uniform;
                    var lg = Kernels.ForwardAll(Tok(prefix.ToArray()), w);
                    for (int j = 0; j < 256; j++) maxDiff = Math.Max(maxDiff, Math.Abs(lg[(t - 1) * 256 + j] - full[(t - 1) * 256 + j]));
                    return SoftmaxRow(lg, t - 1, 256);
                });
            }
            catch (EngineError e) { decErr = e.Message; }
            bool roundtrip = dec != null && dec.SequenceEqual(x);
            double coded = bits.Count, baseBits = 8.0 * n, gain = baseBits - coded;
            bool within = coded <= quant + 2 + 1e-9;
            var rep = Head(op, (roundtrip ? "the text decodes back exactly" : "the text does not decode back") + "; " + U.PyRepr(coded) + " bits against " + U.PyRepr(baseBits) + " for the uniform byte code",
                roundtrip && within ? "consistent" : "inconsistent", null);
            rep["witness"] = about;
            rep["rail_I"] = new JObj().Set("text_bytes", (long)n).Set("coded_bits", coded).Set("roundtrip", roundtrip).Set("decode_error", decErr);
            rep["rail_II"] = new JObj().Set("status", ST_LOGS).Set("rule", "ideal code length = sum of -log2 p(byte | prefix); the first byte of a model witness is coded uniformly (8 bits)")
                .Set("ideal_bits", ideal).Set("bits_per_byte_ideal", ideal / n).Set("ce_nats", ce)
                .Set("ce_rule", "mean of -ln p over bytes 2..n, the definition of next_token_ce");
            rep["rail_III"] = new JObj().Set("rule", "admit the witness as a compressor iff its coded length is below the uniform byte code (8 bits per byte)")
                .Set("baseline_bits", baseBits).Set("gain_bits", gain).Set("admitted_as_compressor", gain > 0).Set("bits_per_byte_coded", coded / n);
            rep["rail_IV"] = new JObj().Set("status", ST_LIN).Set("rule", "coded length = quantised ideal length + a remainder of at most 2 bits (Witten-Neal-Cleary coder)")
                .Set("quantised_ideal_bits", quant).Set("remainder_bits", coded - quant).Set("bound_bits", 2.0).Set("within_bound", within)
                .Set("prefix_vs_full_max_abs_logit_diff", w != null ? (object)maxDiff : null)
                .Set("prefix_check", w != null ? "the decoder recomputes every step's probabilities from the decoded prefix alone; the encoder used one forward pass over the whole text" : "a unigram has no context");
            rep["retraction"] = Retraction(new JObj().Set("coded_bits", baseBits), "witness switched off: the uniform byte code, 8 bits per byte");
            return rep;
        }

        // ---------------- reason selftest: MacKay's worked numbers ----------------
        static void Check(List<object> l, string name, string source, object printed, double computed, double expected, double tol)
        {
            l.Add(new JObj().Set("check", name).Set("source", source).Set("printed", printed).Set("expected", expected).Set("computed", Num(computed))
                .Set("tolerance", tol).Set("ok", U.IsFinite(computed) && Math.Abs(computed - expected) <= tol));
        }

        static JObj Spec(string json) { return SpecOf(json, "selftest"); }

        public static JObj SelfTest()
        {
            var l = new List<object>();
            // (2.16)-(2.18): Jo's test, and the same result entered twice
            var jo = Bayes(Spec("{\"hypotheses\":[\"disease\",\"healthy\"],\"prior\":[0.01,0.99],\"evidence\":[{\"name\":\"positive test\",\"tags\":[\"test-1\"],\"likelihood\":[0.95,0.05]},{\"name\":\"positive test again\",\"tags\":[\"test-1\"],\"likelihood\":[0.95,0.05]}]}"));
            Check(l, "P(disease | positive test)", "MacKay (2.16)-(2.18)", "0.16", jo.Obj("posterior").Dbl("disease"), 19.0 / 118.0, 1e-12);
            Check(l, "the same test entered twice is not admitted (posterior unchanged)", "8S independence gate on provenance", null,
                ((List<object>)jo["rejected"]).Count, 1, 0);
            Check(l, "gates off: the duplicate is double-counted", "retraction (by construction, not evidence)", null,
                jo.Obj("retraction").Obj("gates_off").Obj("posterior").Dbl("disease"), 0.009025 / (0.009025 + 0.002475), 1e-12);
            // (1.18)-(1.23): R3 with f = 0.1, received 011
            var r3 = Bayes(Spec("{\"hypotheses\":[\"s=0\",\"s=1\"],\"prior\":[0.5,0.5],\"evidence\":[{\"name\":\"r1=0\",\"tags\":[\"bit-1\"],\"likelihood\":[0.9,0.1]},{\"name\":\"r2=1\",\"tags\":[\"bit-2\"],\"likelihood\":[0.1,0.9]},{\"name\":\"r3=1\",\"tags\":[\"bit-3\"],\"likelihood\":[0.1,0.9]}]}"));
            Check(l, "P(s = 1 | r = 011), f = 0.1", "MacKay (1.18)-(1.23)", null, r3.Obj("posterior").Dbl("s=1"), 0.9, 1e-12);
            Check(l, "likelihood ratio of r = 011", "MacKay (1.23): ((1-f)/f)^(2-1) = 9", null, Math.Exp(r3.Obj("rail_IV").Dbl("margin_log_odds")), 9.0, 1e-9);
            // (1.36): bit error of R3 at f = 0.1 as the Bayes risk of the layer's own MAP decisions
            double f = 0.1, pb = 0;
            for (int pat = 0; pat < 8; pat++)
            {
                var ev = new List<string>();
                for (int bit = 0; bit < 3; bit++)
                {
                    int rn = (pat >> bit) & 1;
                    ev.Add("{\"tags\":[\"bit-" + bit.ToString(U.Inv) + "\"],\"likelihood\":[" + U.PyRepr(rn == 0 ? 1 - f : f) + "," + U.PyRepr(rn == 1 ? 1 - f : f) + "]}");
                }
                var post = Bayes(Spec("{\"hypotheses\":[\"0\",\"1\"],\"prior\":[0.5,0.5],\"evidence\":[" + string.Join(",", ev) + "]}"));
                int dec = post.Obj("posterior").Dbl("1") > 0.5 ? 1 : 0;
                for (int s = 0; s < 2; s++)
                {
                    double pr = 0.5;
                    for (int bit = 0; bit < 3; bit++) pr *= ((pat >> bit) & 1) == s ? 1 - f : f;
                    if (dec != s) pb += pr;
                }
            }
            Check(l, "bit error of R3 at f = 0.1 (Bayes risk of the MAP decoder)", "MacKay (1.36): 3f^2 - 2f^3", null, pb, 3 * f * f - 2 * f * f * f, 1e-12);
            // (1.35): capacity of the BSC
            Check(l, "capacity of the BSC at f = 0.1", "MacKay (1.35): 1 - H2(f)", null, 1 - EntropyBits(new[] { 0.1, 0.9 }), 0.5310044064107188, 1e-12);
            // (3.24)-(3.27): Oliver's blood
            var ol = Bayes(Spec("{\"hypotheses\":[\"present\",\"absent\"],\"evidence\":[{\"tags\":[\"scene\"],\"likelihood\":[0.01,0.012]}]}"));
            Check(l, "likelihood ratio for Oliver", "MacKay (3.26)", "0.83", ol.Obj("posterior").Dbl("present") / ol.Obj("posterior").Dbl("absent"), 1 / 1.2, 1e-12);
            var ab = Bayes(Spec("{\"hypotheses\":[\"present\",\"absent\"],\"evidence\":[{\"tags\":[\"scene\"],\"likelihood\":[0.6,0.012]}]}"));
            Check(l, "likelihood ratio for a suspect of type AB", "MacKay (3.27)", "50", ab.Obj("posterior").Dbl("present") / ab.Obj("posterior").Dbl("absent"), 50.0, 1e-9);
            // (3.16): Laplace's rule of succession, the smoothing of the unigram witness
            Check(l, "Laplace's rule with F_a = 3, F_b = 1", "MacKay (3.16): (F_a + 1)/(F_a + F_b + 2)", null, UnigramWitness.Smoothed(3, 4, 2, 1.0), 4.0 / 6.0, 1e-15);
            // (1.26)-(1.34): the (7,4) Hamming code corrects every single-bit error
            int[,] GT = { { 1, 0, 0, 0 }, { 0, 1, 0, 0 }, { 0, 0, 1, 0 }, { 0, 0, 0, 1 }, { 1, 1, 1, 0 }, { 0, 1, 1, 1 }, { 1, 0, 1, 1 } };
            int[,] H = { { 1, 1, 1, 0, 1, 0, 0 }, { 0, 1, 1, 1, 0, 1, 0 }, { 1, 0, 1, 1, 0, 0, 1 } };
            int hg = 0;
            for (int i = 0; i < 3; i++) for (int j = 0; j < 4; j++) { int s = 0; for (int k = 0; k < 7; k++) s += H[i, k] * GT[k, j]; hg += s % 2; }
            int corrected = 0;
            for (int msg = 0; msg < 16; msg++)
                for (int flip = 0; flip < 7; flip++)
                {
                    var t = new int[7];
                    for (int k = 0; k < 7; k++) { int s = 0; for (int j = 0; j < 4; j++) s += GT[k, j] * ((msg >> j) & 1); t[k] = s % 2; }
                    var r = (int[])t.Clone();
                    r[flip] ^= 1;
                    var z = new int[3];
                    for (int i = 0; i < 3; i++) { int s = 0; for (int k = 0; k < 7; k++) s += H[i, k] * r[k]; z[i] = s % 2; }
                    for (int k = 0; k < 7; k++) if (H[0, k] == z[0] && H[1, k] == z[1] && H[2, k] == z[2]) { r[k] ^= 1; break; }
                    if (r.SequenceEqual(t)) corrected++;
                }
            Check(l, "H G^T = 0 over F2", "MacKay (1.26), (1.30)", null, hg, 0, 0);
            Check(l, "single-bit errors corrected by syndrome decoding (16 codewords x 7 positions)", "MacKay (1.25)-(1.34)", null, corrected, 112, 0);
            // the 8S gate: a rank-increment test
            var adm = Admit(Spec("{\"items\":[{\"name\":\"s1\",\"code\":[1,0,0],\"gain_bits\":2.0},{\"name\":\"s2\",\"code\":[0,1,0],\"gain_bits\":1.0},{\"name\":\"s3\",\"code\":[1,1,0],\"gain_bits\":0.7},{\"name\":\"s4\",\"code\":[0,0,1],\"gain_bits\":0.0},{\"name\":\"s5\",\"code\":[1,1,0.001],\"gain_bits\":0.4},{\"name\":\"s6\",\"code\":[0,0,2],\"gain_bits\":0.3}]}"));
            Check(l, "rank after the 8S admission of six steps", "8S Theorem A: rank(C5) = rank(C4) + [eta_ind > 0]", null, adm.Long("rank"), 3, 0);
            Check(l, "eta_ind of a step in the span of admitted steps", "8S independence gate", null, ((JObj)adm.Obj("rail_III").Arr("items")[2]).Dbl("eta_ind"), 0.0, 1e-12);
            // MacKay chapter 6: arithmetic coding of a skewed source
            var rng = Pcg64.FromSeed(6);
            var pw = new double[256];
            double zz = 0;
            for (int j = 0; j < 256; j++) { pw[j] = 1.0 / ((1.0 + j) * (1.0 + j)); zz += pw[j]; }
            for (int j = 0; j < 256; j++) pw[j] /= zz;
            var src = new byte[400];
            for (int i = 0; i < src.Length; i++)
            {
                double u = rng.NextDouble(), cum = 0;
                int s = 255;
                for (int j = 0; j < 256; j++) { cum += pw[j]; if (u < cum) { s = j; break; } }
                src[i] = (byte)s;
            }
            var PP = Enumerable.Repeat(pw, src.Length).ToArray();
            var enc = ArithCoder.Encode(src, PP);
            var back = ArithCoder.Decode(enc, src.Length, pre => pw);
            double qi = 0;
            for (int i = 0; i < src.Length; i++) qi += ArithCoder.QuantisedBits(pw, src[i]);
            Check(l, "arithmetic coding round trip (400 symbols)", "MacKay chapter 6", null, back.SequenceEqual(src) ? 1 : 0, 1, 0);
            Check(l, "coded length minus the quantised ideal length is at most 2 bits", "MacKay chapter 6", null, enc.Count - qi <= 2 + 1e-9 ? 1 : 0, 1, 0);
            // MacKay chapter 33: mean field against exact enumeration (reference values computed independently)
            var mf = MeanField(Spec("{\"claims\":[\"A\",\"B\",\"C\"],\"h\":[1.2,-0.4,0.3],\"J\":[[0,0.5,0],[0.5,0,-0.4],[0,-0.4,0]]}"));
            Check(l, "exact marginal of claim A", "complete enumeration (MacKay chapter 21)", null, mf.Obj("marginals").Dbl("A"), 0.7482784821861647, 1e-12);
            Check(l, "mean-field marginal of claim A", "mean field (MacKay chapter 33), 8S gate layer", null, mf.Obj("rail_III").Obj("meanfield").Dbl("A"), 0.759157110268757, 1e-9);
            // R3 over three routes
            var par = Parity(Spec("{\"routes\":[\"a\",\"b\",\"c\"],\"tolerance\":1e-6}"), 1.0, 1.0, 1.5);
            Check(l, "one deviating route is outvoted", "R3 majority decoding, MacKay (1.18)-(1.23)", null, par.Str("outlier") == "c" ? 1 : 0, 1, 0);
            bool refused = false;
            try { Parity(Spec("{\"routes\":[\"a\",\"b\",\"c\"],\"tolerance\":1e-6}"), 1.0, 2.0, 3.0); }
            catch (EngineError) { refused = true; }
            Check(l, "three disagreeing routes are refused", "R3: no majority", null, refused ? 1 : 0, 1, 0);
            bool all = l.All(o => (bool)((JObj)o)["ok"]);
            return new JObj().Set("framework", FRAMEWORK).Set("checks", l).Set("all_pass", all);
        }
    }
}
